//
//  RecordResponseDTO.swift
//  juinjang
//
//  Created by 조유진 on 5/21/24.
//

import Foundation

struct RecordResponseDTO: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: RecordResponse?
}

struct RecordResponse: Codable {
    var recordName: String
    let createdAt: String
    let updatedAt: String
    var recordScript: String
    let recordTime: Int
    let recordUrl: String
    let recordId: Int
    let limjangId: Int
}
