//
//  AppVersionAPI.swift
//  juinjang
//
//  Created by 조유진 on 8/8/25.
//

import Foundation
import Alamofire

public enum AppVersionAPI: TargetType {
    case getLatestAppVersion

    public var path: String {
        switch self {
        case .getLatestAppVersion:
            return "app/version/ios"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getLatestAppVersion:
            return .get
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .getLatestAppVersion:
            return []
        }
    }

    public var parameters: [String : Any]? {
        switch self {
        case .getLatestAppVersion:
            return nil
        }
    }
    
    public var interceptor: AuthInterceptor? {
        switch self {
        case .getLatestAppVersion: return nil
        }
    }
}

