//
//  NetworkError.swift
//  byeolbolil-mobile
//
//  Created by Quarang on 3/2/26.
//

import Foundation

/// 에러 케이스 정의
enum NetworkError: Error {
    case invalidURL             // 유효하지 않은 URL
    case unauthorized           // 401 → 로그인 화면으로
    case requestFailed(Error)   // 요청 실패
    case notFound               // 404
    case serverError(Int)       // 500번대
    case encodingFailed         // 인코딩 실패
    case decodingFailed         // 디코딩 실패
    case noInternetConnection   // 오프라인
    case unknown                // 그 외
}
