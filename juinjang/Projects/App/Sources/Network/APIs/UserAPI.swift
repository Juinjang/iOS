//
//  UserAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 5/18/25.
//

import Foundation
import Alamofire

enum UserAPI: TargetType {
    case getProfileInfo
    case patchProfileIntroduction(String)

    var path: String {
        switch self {
        case .getProfileInfo:
            return "profile"
        case .patchProfileIntroduction:
            return "profile/introduction"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfileInfo:
            return .get
        case .patchProfileIntroduction:
            return .patch
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getProfileInfo,
                .patchProfileIntroduction:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getProfileInfo:
            return nil
        case .patchProfileIntroduction(let text):
            return ["introduction": text]
        }
    }
    
    var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

