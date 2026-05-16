//
//  RequestTask.swift
//  byeolbolil-mobile
//
//  Created by Quarang on 3/2/26.
//

import Foundation

/// Request parameter style for an API endpoint.
enum RequestTask: Sendable {
    case plain
    case query([String: String])
    case body(any Encodable & Sendable)
    case queryAndBody([String: String], any Encodable & Sendable)
}
