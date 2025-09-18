//
//  APIError.swift
//  juinjang
//
//  Created by 조유진 on 5/29/24.
//

import Foundation

public enum APIError: Int, LocalizedError {
    case accessTokenExpired = 419   // 액세스토큰이 만료되었을 때
    case refreshTokenExpired = 418  // 액세스토큰 갱신에 실패했을 때
    
    var errorDescription: String? {
        switch self {
        case .accessTokenExpired:
            return "액세스 토큰이 만료되었습니다. 토큰을 갱신해주세요."
        case .refreshTokenExpired:
            return "로그인이 필요합니다."
        }
    }
}


public enum CodeTokenError: String, LocalizedError {
    case token401 = "TOKEN401"
    case token402 = "TOKEN402"

    var errorDescription: String? {
        switch self {
        case .token401: "토큰값이 존재하지 않습니다."
        case .token402: "유효하지 않은 Refresh Token입니다. 다시 로그인하세요."
        }
    }
}

public enum CodeCommonError: String, LocalizedError {
    case common400 = "COMMON400"
    case common500 = "COMMON500"
    
    var errorDescription: String? {
        switch self {
        case .common400: "잘못된 요청입니다."
        case .common500: "서버 에러, 관리자에게 문의 바랍니다."
        }
    }
}
