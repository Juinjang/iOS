//
//  UserAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 5/18/25.
//

import Foundation
import Alamofire

enum UserAPI: TargetType {
    case getProfileIntroduction
    case patchProfileIntroduction(String)
    case regenerateAccessToken

    var path: String {
        switch self {
        case .getProfileIntroduction:
            return "profile"
        case .patchProfileIntroduction:
            return "profile/introduction"
        case .regenerateAccessToken:
            return "auth/regenerate-token"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfileIntroduction:
            return .get
        case .patchProfileIntroduction:
            return .patch
        case .regenerateAccessToken:
            return .post
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getProfileIntroduction,
                .patchProfileIntroduction,
                .regenerateAccessToken:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getProfileIntroduction:
            return nil
        case .patchProfileIntroduction(let text):
            return ["introduction": text]
        case .regenerateAccessToken:
            let dto = RefreshDto(
                accessToken: UserDefaultManager.shared.accessToken,
                refreshToken: UserDefaultManager.shared.refreshToken,
                email: UserDefaultManager.shared.email
            )
            dump(dto)
            return dto.toDictionary()
        }
    }
    
    var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

