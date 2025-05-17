//
//  NoteAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import Foundation
import Alamofire

enum NoteAPI: TargetType {
    case getShareableNotes
    case getChecklistConditions(Int)
    case getMyImjangDetail(Int)
    case postImjang(ImjangRequestDTO)
    case patchImjang(Int, ImjangUpdateRequestDTO)

    var path: String {
        switch self {
        case .getShareableNotes:
            return "v2/users/notes/shareable"
        case .getChecklistConditions(let noteID):
            return "v2/note/\(noteID)/checklist-condition"
        case .getMyImjangDetail(let noteID):
            return "v2/users/notes/\(noteID)"
        case .postImjang:
            return "v2/users/notes"
        case .patchImjang(let noteID,_):
            return "v2/users/notes/\(noteID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getShareableNotes,
                .getChecklistConditions,
                .getMyImjangDetail:
            return .get
        case .postImjang:
            return .post
        case .patchImjang:
            return .patch
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getShareableNotes,
                .getChecklistConditions,
                .getMyImjangDetail,
                .postImjang,
                .patchImjang:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getShareableNotes,
                .getChecklistConditions,
                .getMyImjangDetail:
            return nil
        case .postImjang(let param as Encodable),
                .patchImjang(_, let param as Encodable):
            return param.toDictionary()
        }
    }
    
    var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

