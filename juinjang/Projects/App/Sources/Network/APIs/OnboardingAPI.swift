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
    case getMyNoteReport

    var path: String {
        switch self {
        case .getRecentNotes:
            return "mock/notes/recent"
        case .getMyNotes:
            return "mock/notes/mynotes"
        case .getMyNoteCheckLists:
            return "mock/notes/checklists"
        case .getMyNoteDetail:
            return "mock/notes/detail"
        case .getMyNoteRecordMemo:
            return "mock/notes/records"
        case .getMyNoteReport:
            return "mock/notes/report"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getRecentNotes,
                .getMyNotes,
                .getMyNoteCheckLists,
                .getMyNoteDetail,
                .getMyNoteRecordMemo,
                .getMyNoteReport:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getRecentNotes,
                .getMyNotes,
                .getMyNoteCheckLists,
                .getMyNoteDetail,
                .getMyNoteRecordMemo,
                .getMyNoteReport:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getRecentNotes,
                .getMyNotes,
                .getMyNoteCheckLists,
                .getMyNoteDetail,
                .getMyNoteRecordMemo,
                .getMyNoteReport:
            return nil
        }
    }
    
    var interceptor: AuthInterceptor? {
        switch self {
        case .getRecentNotes,
                .getMyNotes,
                .getMyNoteCheckLists,
                .getMyNoteDetail,
                .getMyNoteRecordMemo,
                .getMyNoteReport:
            return nil
        }
    }
}

