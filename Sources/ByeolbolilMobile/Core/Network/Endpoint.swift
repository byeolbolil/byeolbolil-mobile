//
//  Endpoint.swift
//  byeolbolil-mobile
//
//  Created by Quarang on 3/1/26.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// API endpoint definitions.
enum Endpoint: Sendable {
    case spots
    case analyze
    case forecast
    case bookmarks
    case setBookmark(request: RequestTask)
    case deleteBookmark(id: Int)
    case updateBookmark(id: Int, request: RequestTask)
    case login(request: RequestTask)
    case register(request: RequestTask)
    case logout(request: RequestTask)
    case reissue(request: RequestTask)
    case bookMarkToday
    case email
    case user
}

// MARK: - Properties
extension Endpoint {
    /// Base URL for API requests.
    var baseURL: String { AppConfig.apiBaseURL }

    /// API path.
    var path: String {
        switch self {
        case .spots:
            return "/spots"
        case .analyze:
            return "/analyze"
        case .forecast:
            return "/forecast"
        case .bookmarks, .setBookmark:
            return "/bookmarks"
        case let .deleteBookmark(id):
            return "/bookmarks/\(id)"
        case let .updateBookmark(id, _):
            return "/bookmarks/\(id)"
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .logout:
            return "/auth/logout"
        case .reissue:
            return "/auth/reissue"
        case .bookMarkToday:
            return "/bookmarks/today"
        case .email:
            return "/exits/email"
        case .user:
            return "/members/me"
        }
    }

    /// HTTP method.
    var method: HTTPMethod {
        switch self {
        case .spots, .analyze, .forecast, .bookmarks, .bookMarkToday, .email, .user:
            return .get
        case .setBookmark, .login, .register, .logout, .reissue:
            return .post
        case .deleteBookmark:
            return .delete
        case .updateBookmark:
            return .patch
        }
    }

    /// Request parameter style.
    var task: RequestTask {
        switch self {
        case let .setBookmark(request):
            return request
        case let .updateBookmark(_, request):
            return request
        case let .login(request):
            return request
        case let .logout(request):
            return request
        case let .register(request):
            return request
        case let .reissue(request):
            return request
        default:
            return .plain
        }
    }
}

// MARK: - URLRequest
extension Endpoint {
    /// Builds a URLRequest for this endpoint.
    func asURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        switch task {
        case .plain:
            break

        case let .query(params):
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            request.url = components.url

        case let .body(encodable):
            do {
                request.httpBody = try JSONEncoder().encode(encodable)
            } catch {
                throw NetworkError.encodingFailed
            }

        case let .queryAndBody(params, encodable):
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            request.url = components.url
            do {
                request.httpBody = try JSONEncoder().encode(encodable)
            } catch {
                throw NetworkError.encodingFailed
            }
        }

        return request
    }
}

/// Refresh-token request body.
struct RefreshRequest: Encodable, Sendable {
    let refreshToken: String
}

/// Token refresh response body.
struct TokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
