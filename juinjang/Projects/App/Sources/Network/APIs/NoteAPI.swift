//
//  NoteAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import Foundation
import Alamofire

enum NoteAPI: TargetType {
    case getShareableNoteList(ShareableNoteRequestDTO)
    case getNoteChecklistConditionList(Int)
    case getNoteChecklist(Int)
    case getNoteDetail(Int)
    case getNoteList(sort: String, keyword: String)
    case postAddNote(AddNoteRequestDTO)
    case postCheckList(Int, [CheckListRequestDto])
    case patchNote(Int, NoteUpdateRequestDTO)

    var path: String {
        switch self {
        case .getShareableNoteList:
            return "v2/users/notes/shareable"
        case .getNoteChecklistConditionList(let noteID):
            return "v2/users/notes/\(noteID)/checklist-condition"
        case .getNoteChecklist(let noteID):
            return "v2/checklist/\(noteID)"
        case .getNoteDetail(let noteID):
            return "v2/users/notes/\(noteID)"
        case .getNoteList:
            return "v2/users/notes"
        case .postAddNote:
            return "v2/users/notes/init"
        case .postCheckList(let noteID, _):
            return "v2/checklist/\(noteID)"
        case .patchNote(let noteID,_):
            return "v2/users/notes/init/\(noteID)"
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
        case .postAddNote,
                .postCheckList:
            return .post
        case .patchNote:
            return .patch
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getNoteChecklistConditionList,
                .getNoteChecklist,
                .getNoteDetail,
                .postAddNote,
                .postCheckList,
                .patchNote:
            return []
        case let .getNoteList(sort, keyword):
            return [URLQueryItem(name: "sort", value: sort),
                    URLQueryItem(name: "keyword", value: keyword)]
        case .getShareableNoteList(let param as Encodable):
            return param.toQueryItems()
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
        case .postAddNote(let param as Encodable),
                .patchNote(_, let param as Encodable):
            return param.toDictionary()
        default:
            return nil
        }
    }
    
    var bodyData: Data? {
        switch self {
        case .postCheckList(_, let params as Encodable):
            return params.toArray()
        default:
            return nil
        }
    }
    
    
    var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

