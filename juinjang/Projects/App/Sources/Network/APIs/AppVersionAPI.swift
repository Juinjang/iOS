//
//  AppVersionAPI.swift
//  juinjang
//
//  Created by 조유진 on 8/8/25.
//

import Foundation
import Alamofire

enum AppVersionAPI: TargetType {
    case getLatestAppVersion

    var path: String {
        switch self {
        case .getLatestAppVersion:
            return "app/version/ios"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getLatestAppVersion:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getLatestAppVersion:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getLatestAppVersion:
            return nil
        }
    }
    
    var interceptor: AuthInterceptor? {
        switch self {
        case .getLatestAppVersion: return nil
        }
    }
}

