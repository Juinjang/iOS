//
//  NetworkError.swift
//  juinjang
//
//  Created by 강동영 on 2/24/25.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case failedRequest
    case noData
    case invalidUrl
    case invalidResponse
    case invalidData
    
    public var errorDescription: String? {
        switch self {
        case .failedRequest:
            return "요청에 실패하였습니다. 다시 시도해주세요"
        case .noData:
            return "응답 데이터가 없습니다."
        case .invalidUrl:
            return "유효하지 않은 URL입니다."
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        }
    }
}
