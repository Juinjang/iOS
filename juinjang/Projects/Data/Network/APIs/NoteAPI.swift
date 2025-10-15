//
//  NoteAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import Foundation
import Alamofire
import DataModel

public enum NoteAPI: TargetType {
    case getShareableNoteList(AddShareableNoteRequest)
    case getNoteChecklistConditionList(Int)
    case getNoteChecklist(Int)
    case getNoteDetail(Int)
    case getNoteList(sort: String, keyword: String)
    case postNote(AddNoteRequest)
    case postCheckList(Int, [AddNoteCheckListAnswerRequest])
    case patchNote(Int, EditNoteRequest)

    public var path: String {
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
        case .postNote:
            return "v2/users/notes"
        case .postCheckList(let noteID, _):
            return "v2/checklist/\(noteID)"
        case .patchNote(let noteID,_):
            return "v2/users/notes/\(noteID)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getShareableNoteList,
                .getNoteChecklistConditionList,
                .getNoteChecklist,
                .getNoteDetail,
                .getNoteList:
            return .get
        case .postNote,
                .postCheckList:
            return .post
        case .patchNote:
            return .patch
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .getNoteChecklistConditionList,
                .getNoteChecklist,
                .getNoteDetail,
                .postNote,
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

    public var parameters: [String : Any]? {
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
        default:
            return nil
        }
    }
    
    public var bodyData: Data? {
        switch self {
        case .postCheckList(_, let params as Encodable):
            return params.toArray()
        default:
            return nil
        }
    }
    
    
    public var interceptor: AuthInterceptor? {
        return AuthInterceptor()
    }
}

