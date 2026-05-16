//
//  AppConfig.swift
//  byeolbolil-mobile
//
//  Created by Quarang on 3/1/26.
//

import Foundation

enum AppEnvironment {
    case dev
    case staging
    case prod
}

enum AppConfig {
    static let current: AppEnvironment = {
        #if STAGING
        return .staging
        #elseif DEBUG
        return .dev
        #else
        return .prod
        #endif
    }()

    static var baseURL: String {
        switch current {
        case .dev:     return "https://dev-api.byeolbolil.xyz"
        case .staging: return "https://staging-api.byeolbolil.xyz"
        case .prod:    return "https://api.byeolbolil.xyz"
        }
    }

    static var apiVersion: String { "/api/v1" }

    static var apiBaseURL: String { "\(baseURL)\(apiVersion)" }
}
