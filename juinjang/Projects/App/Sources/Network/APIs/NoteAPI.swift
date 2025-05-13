//
//  NoteAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import Foundation
import Alamofire

enum NoteAPI: TargetType {
    case getMyNotes(NoteRequestDTO)
    case getShareableNotes
    case postLikeNote(Int)
    case deleteLikeNote(Int)

    var path: String {
        switch self {
        case .getMyNotes:
            return "v2/users/shared-notes"
        case .getShareableNotes:
            return "v2/users/notes/shareable"
        case .postLikeNote(let noteId):
            return "v2/shared-notes/\(noteId)/likes"
        case .deleteLikeNote(let noteId):
            return "v2/shared-notes/\(noteId)/likes"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getShareableNotes,
                .getMyNotes:
            return .get
        case .postLikeNote:
            return .post
        case .deleteLikeNote:
            return .delete
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .getMyNotes(let noteRequestDTO):
            return noteRequestDTO.toQueryItems()
        case .getShareableNotes,
                .postLikeNote,
                .deleteLikeNote:
            return []
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getMyNotes,
                .getShareableNotes,
                .postLikeNote,
                .deleteLikeNote:
            return nil
        }
    }
}
