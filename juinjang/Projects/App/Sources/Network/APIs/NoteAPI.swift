//
//  NoteAPI.swift
//  juinjang
//
//  Created by KimDongWoo on 4/30/25.
//

import Foundation
import Alamofire

enum NoteAPI: TargetType {
    case getMyNotes
    case getShareableNotes

    var path: String {
        switch self {
        case .getMyNotes:
            return "v2/users/notes"
        case .getShareableNotes:
            return "v2/users/notes/shareable"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getShareableNotes,
                .getMyNotes:
            return .get
        }
    }

    var queryItems: [URLQueryItem] {
        return []
    }

    var parameters: [String : Any]? {
        return nil
    }
}
