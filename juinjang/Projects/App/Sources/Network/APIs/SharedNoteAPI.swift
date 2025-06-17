//
//  SharedNoteAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import Foundation
import Alamofire

enum SharedNoteAPI: TargetType {
    case getMyNoteList(MyNoteRequestDTO)
    case getExploreNoteList(ExploreNoteRequestDTO)
    case getNoteDetail(Int)
    case getNoteDetailReport(Int)
    case getNoteDetailChecklist(Int)
    case postLikeNote(Int)
    case postSharedNote(Int, NoteShareRequestDTO)
    case postPurchaseNote(Int)
    case postNoteReport(NoteReportRequestDTO)
    case deleteLikeNote(Int)
    case deleteSharedNote(Int)

    var path: String {
        switch self {
        case .getMyNoteList:
            return "v2/users/shared-notes"
        case .getExploreNoteList:
            return "v2/explore"
        case .getNoteDetail(let noteId):
            return "v2/shared-notes/\(noteId)"
        case .getNoteDetailReport(let noteId):
            return "v2/shared-notes/\(noteId)/report"
        case .getNoteDetailChecklist(let noteId):
            return "v2/shared-notes/\(noteId)/checklist"
        case .postLikeNote(let noteID):
            return "v2/shared-notes/\(noteID)/likes"
        case .postSharedNote(let noteID, _):
            return "v2/\(noteID)"
        case .postPurchaseNote(let noteID):
            return "v2/shared-notes/\(noteID)/purchase"
        case .postNoteReport:
            return "v2/reports/shared-note"
        case .deleteLikeNote(let noteID):
            return "v2/shared-notes/\(noteID)/likes"
        case .deleteSharedNote(let noteID):
            return "v2/shared-notes/\(noteID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getMyNoteList,
                .getExploreNoteList,
                .getNoteDetail,
                .getNoteDetailReport,
                .getNoteDetailChecklist:
            return .get
        case .postLikeNote,
                .postSharedNote,
                .postPurchaseNote,
                .postNoteReport:
            return .post
        case .deleteLikeNote,
                .deleteSharedNote:
            return .delete
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getMyNoteList(let param as Encodable),
                .getExploreNoteList(let param as Encodable):
            return param.toQueryItems()
        case .getNoteDetail,
                .getNoteDetailReport,
                .getNoteDetailChecklist,
                .postLikeNote,
                .postSharedNote,
                .postPurchaseNote,
                .postNoteReport,
                .deleteLikeNote,
                .deleteSharedNote:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getMyNoteList,
                .getExploreNoteList,
                .getNoteDetail,
                .getNoteDetailReport,
                .getNoteDetailChecklist,
                .postLikeNote,
                .postPurchaseNote,
                .deleteLikeNote,
                .deleteSharedNote:
            return nil
        case .postSharedNote(_, let param as Encodable),
                .postNoteReport(let param as Encodable):
            return param.toDictionary()
        }
    }
    
    var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

