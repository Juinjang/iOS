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
    case getMyNoteCheckLists
    case getMyNoteDetail
    case getMyNoteRecordMemo

    var path: String {
        switch self {
        case .getRecentNotes:
            return "mock/notes/recent"
        case .getMyNotes:
            return "mock/notes/list"
        case .getMyNoteCheckLists:
            return "mock/notes/checklists"
        case .getMyNoteDetail:
            return "mock/notes/detail"
        case .getMyNoteRecordMemo:
            return "mock/notes/records"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getRecentNotes,
                .getMyNotes,
                .getMyNoteCheckLists,
                .getMyNoteDetail,
                .getMyNoteRecordMemo:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getRecentNotes,
                .getMyNotes,
                .getMyNoteCheckLists,
                .getMyNoteDetail,
                .getMyNoteRecordMemo:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getRecentNotes,
                .getMyNotes,
                .getMyNoteCheckLists,
                .getMyNoteDetail,
                .getMyNoteRecordMemo:
            return nil
        }
    }
    
    var interceptor: AuthInterceptor? {
        switch self {
        case .getRecentNotes,
                .getMyNotes,
                .getMyNoteCheckLists,
                .getMyNoteDetail,
                .getMyNoteRecordMemo:
            return nil
        }
    }
}

