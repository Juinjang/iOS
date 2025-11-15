//
//  SharedNoteAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import Foundation
import Alamofire
import CoreCommon
import DataModel

public enum SharedNoteAPI: TargetType {
    case getMyNoteList(SearchSharedMyNoteRequest)
    case getExploreNoteList(SearchSharedNoteRequest)
    case getNoteDetail(Int)
    case getNoteDetailReport(Int)
    case getNoteDetailChecklist(Int)
    case postLikeNote(Int)
    case postSharedNote(Int, AddShareableNoteRequest)
    case postPurchaseNote(Int)
    case postNoteReport(AddSharedNoteReportRequest)
    case deleteLikeNote(Int)
    case deleteSharedNote(Int)

    public var path: String {
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
            return "v2/shared-note/\(noteId)/checklist"
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

    public var method: HTTPMethod {
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
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .getMyNoteList(let param as Encodable):
            return param.toQueryItems()
        case .getExploreNoteList(let param):
            var items = param.code?.map { URLQueryItem(name: "code", value: $0) } ?? []

            return  items + [
                URLQueryItem(name: "sort", value: param.sort),
                URLQueryItem(name: "propertyType", value: param.propertyType),
                URLQueryItem(name: "priceType", value: param.priceType),
                URLQueryItem(name: "page", value: "\(param.page)"),
                URLQueryItem(name: "size", value: "\(param.size)"),
                URLQueryItem(name: "keyword", value: param.keyword)
            ]
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

    public var parameters: [String : Any]? {
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

