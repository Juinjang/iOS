//
//  SharedNoteAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import Foundation
import Alamofire

enum SharedNoteAPI: TargetType {
    case getMyNotes(NoteRequestDTO)
    case getExploreNotes(ExploreNoteRequestDTO)
    case postLikeNote(Int)
    case postShareNote(Int, NoteShareRequestDTO)
    case postPurchaseNote(Int)
    case deleteLikeNote(Int)
    case deleteSharedNote(Int)

    var path: String {
        switch self {
        case .getMyNotes:
            return "v2/users/shared-notes"
        case .getExploreNotes(let param):
            return "v2/explore"
        case .postLikeNote(let noteID):
            return "v2/shared-notes/\(noteID)/likes"
        case .postShareNote(let noteID, _):
            return "v2/shared-notes/\(noteID)"
        case .postPurchaseNote(let noteID):
            return "v2/shared-notes/\(noteID)/purchase"
        case .deleteLikeNote(let noteID):
            return "v2/shared-notes/\(noteID)/likes"
        case .deleteSharedNote(let noteID):
            return "v2/shared-notes/\(noteID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getMyNotes,
                .getExploreNotes:
            return .get
        case .postLikeNote,
                .postShareNote,
                .postPurchaseNote:
            return .post
        case .deleteLikeNote,
                .deleteSharedNote:
            return .delete
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getMyNotes(let param as Encodable),
                .getExploreNotes(let param as Encodable):
            return param.toQueryItems()
        case .postLikeNote,
                .postShareNote,
                .postPurchaseNote,
                .deleteLikeNote,
                .deleteSharedNote:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getMyNotes,
                .getExploreNotes,
                .postLikeNote,
                .postPurchaseNote,
                .deleteLikeNote,
                .deleteSharedNote:
            return nil
        case .postShareNote(_, let param):
            return param.toDictionary()
        }
    }
    
    var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

