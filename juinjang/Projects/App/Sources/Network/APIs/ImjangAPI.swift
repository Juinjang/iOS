//
//  ImjangAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 5/14/25.
//

import Foundation
import Alamofire

enum ImjangAPI: TargetType {
    case getImjangDetail(Int)
    case getImjangDetailReport(Int)
    case getImjangDetailChecklist(Int)

    var path: String {
        switch self {
        case .getImjangDetail(let noteId):
            return "v2/shared-notes/\(noteId)"
        case .getImjangDetailReport(let noteId):
            return "v2/notes/\(noteId)/report"
        case .getImjangDetailChecklist(let noteId):
            return "v2/shared-note/\(noteId)/checklist"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getImjangDetail,
                .getImjangDetailReport,
                .getImjangDetailChecklist:
            return .get
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .getImjangDetail,
                .getImjangDetailReport,
                .getImjangDetailChecklist:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getImjangDetail,
                .getImjangDetailReport,
                .getImjangDetailChecklist:
            return nil
        }
    }
    
    var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}
