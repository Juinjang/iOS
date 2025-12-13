//
//  OnboardingAPI.swift
//  App
//
//  Created by KimDongWoo on 12/13/25.
//

import Foundation
import Alamofire

enum OnboardingAPI: TargetType {
    case getRecentNotes

    var path: String {
        switch self {
        case .getRecentNotes:
            return "mock/notes/recent"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getRecentNotes:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getRecentNotes:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getRecentNotes:
            return nil
        }
    }
    
    var interceptor: AuthInterceptor? {
        switch self {
        case .getRecentNotes: return nil
        }
    }
}

