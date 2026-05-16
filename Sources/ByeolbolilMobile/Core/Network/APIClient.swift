//
//  APIClient.swift
//  byeolbolil-mobile
//
//  Created by Quarang on 3/1/26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - APIClientProtocol

protocol APIClientProtocol {
    func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T
}

/// APIClient
actor APIClient: APIClientProtocol {
    private let session: URLSession
    private let tokenStorage: TokenStorageProtocol
    private var refreshTask: Task<Void, Error>?

    init(
        session: URLSession = .shared,
        tokenStorage: TokenStorageProtocol = TokenStorage()
    ) {
        self.session = session
        self.tokenStorage = tokenStorage
    }

    /// 요청
    func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T {
        // 요청 구성 + 토큰 주입
        let urlRequest = adapt(try endpoint.asURLRequest())

        // 실제 요청 실행
        let (data, response) = try await session.data(for: urlRequest)
        
        // 401이면 토큰 갱신 후 재시도
        if let http = response as? HTTPURLResponse, http.statusCode == 401 {
            return try await retry(endpoint)
        }

        return try decode(data, response: response)
    }
}

// MARK: - adapt
extension APIClient {
    /// 모든 요청에 Authorization 헤더 주입
    private func adapt(_ request: URLRequest) -> URLRequest {
        var request = request
        if let token = tokenStorage.accessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

// MARK: - retry
extension APIClient {
    /// 토큰 갱신 후 원래 요청 재시도
    private func retry<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T {
        try await refreshTokenIfNeeded()

        // 갱신된 토큰으로 재시도
        let retryRequest = adapt(try endpoint.asURLRequest())
        let (data, response) = try await session.data(for: retryRequest)

        // 재시도도 401이면 완전 만료 → 로그인 화면으로
        if let http = response as? HTTPURLResponse, http.statusCode == 401 {
            tokenStorage.clear()
            throw NetworkError.unauthorized
        }

        return try decode(data, response: response)
    }

    /// 토큰 갱신 — 동시 요청이 몰려도 갱신은 1번만 실행
    private func refreshTokenIfNeeded() async throws {
        // 이미 갱신 중인 Task가 있으면 그것이 끝날 때까지 대기
        if let existing = refreshTask {
            return try await existing.value
        }

        let task = Task<Void, Error> {
            guard let refreshToken = tokenStorage.refreshToken() else {
                throw NetworkError.unauthorized
            }
            // 갱신 요청은 adapt() 없이 전송 (기존 토큰 없이 요청)
            let urlRequest = try Endpoint.reissue(request: .body(RefreshRequest(refreshToken: refreshToken))).asURLRequest()
            let (data, _) = try await session.data(for: urlRequest)

            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            tokenStorage.save(
                accessToken: tokenResponse.accessToken,
                refreshToken: tokenResponse.refreshToken
            )
        }

        refreshTask = task
        defer { refreshTask = nil }
        try await task.value
    }
}

// MARK: - decode

extension APIClient {
    private func decode<T: Decodable & Sendable>(_ data: Data, response: URLResponse) throws -> T {
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        switch http.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed
            }
        case 401: throw NetworkError.unauthorized
        case 404: throw NetworkError.notFound
        case 500...: throw NetworkError.serverError(http.statusCode)
        default:    throw NetworkError.unknown
        }
    }
}
