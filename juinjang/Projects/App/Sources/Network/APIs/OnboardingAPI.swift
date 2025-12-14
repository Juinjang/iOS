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
    case getMyNotes

    var path: String {
        switch self {
        case .getRecentNotes:
            return "mock/notes/recent"
        case .getMyNotes:
            return "mock/notes/list"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getRecentNotes,
                .getMyNotes:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getRecentNotes,
                .getMyNotes:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getRecentNotes,
                .getMyNotes:
            return nil
        }
    }
    
    var interceptor: AuthInterceptor? {
        switch self {
        case .getRecentNotes,
                .getMyNotes: return nil
        }
    }
}

