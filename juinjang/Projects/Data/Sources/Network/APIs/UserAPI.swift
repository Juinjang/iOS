//
//  UserAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 5/18/25.
//

import Foundation
import Alamofire
import Core

public enum UserAPI: TargetType {
    case getProfileInfo
    case patchProfileIntroduction(String)
    case regenerateAccessToken(Refresh)

    public var path: String {
        switch self {
        case .getProfileInfo:
            return "profile"
        case .patchProfileIntroduction:
            return "profile/introduction"
        case .regenerateAccessToken:
            return "auth/regenerate-token"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getProfileInfo:
            return .get
        case .patchProfileIntroduction:
            return .patch
        case .regenerateAccessToken:
            return .post
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .getProfileInfo,
                .patchProfileIntroduction,
                .regenerateAccessToken:
            return []
        }
    }

    public var parameters: [String : Any]? {
        switch self {
        case .getProfileInfo:
            return nil
        case .patchProfileIntroduction(let text):
            return ["introduction": text]
        case .regenerateAccessToken(let model):
            return model.toDictionary()
        }
    }
    
    public var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

