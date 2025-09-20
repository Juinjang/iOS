//
//  RecordResponseDTO.swift
//  juinjang
//
//  Created by 조유진 on 5/21/24.
//

import Foundation

public struct RecordResponse {
    var recordName: String
    let createdAt: String
    let updatedAt: String
    var recordScript: String
    let recordTime: Int
    let recordUrl: String
    let recordId: Int
    let limjangId: Int
}
