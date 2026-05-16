//
//  TokenStorage.swift
//  byeolbolil-mobile
//
//  Created by Quarang on 3/2/26.
//

import Foundation

// 토큰 프로토콜
protocol TokenStorageProtocol {
    /// 토큰 저장
    func save(accessToken: String, refreshToken: String)
    /// 엑세스 토큰
    func accessToken() -> String?
    /// 리프레쉬 토큰
    func refreshToken() -> String?
    /// 토큰 삭제
    func clear()
}

// 토큰 스토리지
final class TokenStorage: TokenStorageProtocol {
    private let accessTokenKey  = "access_token"
    private let refreshTokenKey = "refresh_token"

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save(accessToken: String, refreshToken: String) {
        defaults.set(accessToken,  forKey: accessTokenKey)
        defaults.set(refreshToken, forKey: refreshTokenKey)
    }

    func accessToken() -> String? {
        defaults.string(forKey: accessTokenKey)
    }

    func refreshToken() -> String? {
        defaults.string(forKey: refreshTokenKey)
    }

    func clear() {
        defaults.removeObject(forKey: accessTokenKey)
        defaults.removeObject(forKey: refreshTokenKey)
    }
}
