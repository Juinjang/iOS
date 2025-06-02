//
//  NoteAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import Foundation
import Alamofire

enum NoteAPI: TargetType {
    case getShareableNoteList
    case getNoteChecklistConditionList(Int)
    case getNoteChecklist(Int)
    case getNoteDetail(Int)
    case getNoteList(sort: String, keyword: String)
    case postNote(NoteCreateRequestDTO)
    case patchNote(Int, NoteUpdateRequestDTO)

    var path: String {
        switch self {
        case .getShareableNoteList:
            return "v2/users/notes/shareable"
        case .getNoteChecklistConditionList(let noteID):
            return "v2/users/notes/\(noteID)/checklist-condition"
        case .getNoteChecklist(let noteID):
            return "v2/note/\(noteID)/checklist"
        case .getNoteDetail(let noteID):
            return "v2/users/notes/\(noteID)"
        case .getNoteList:
            return "v2/users/notes"
        case .postNote:
            return "v2/users/notes"
        case .patchNote(let noteID,_):
            return "v2/users/notes/\(noteID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getShareableNoteList,
                .getNoteChecklistConditionList,
                .getNoteChecklist,
                .getNoteDetail,
                .getNoteList:
            return .get
        case .postNote:
            return .post
        case .patchNote:
            return .patch
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getShareableNoteList,
                .getNoteChecklistConditionList,
                .getNoteChecklist,
                .getNoteDetail,
                .postNote,
                .patchNote:
            return []
        case let .getNoteList(sort, keyword):
            return [URLQueryItem(name: "sort", value: sort),
                    URLQueryItem(name: "keyword", value: keyword)]
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getShareableNoteList,
                .getNoteChecklistConditionList,
                .getNoteChecklist,
                .getNoteDetail,
                .getNoteList:
            return nil
        case .postNote(let param as Encodable),
                .patchNote(_, let param as Encodable):
            return param.toDictionary()
        }
    }
    
    var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

