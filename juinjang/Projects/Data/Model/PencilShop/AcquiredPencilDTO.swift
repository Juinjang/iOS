//
//  AcquiredPencilDTO.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

struct AcquiredPencilDTO: Codable, Hashable {
    let acquiredPencilId: Int
    let content: String
    let sharedNoteId: Int
    let acquiredQuantity: Int
    let buildingName: String
    let type: String
    let createdAt: String
    var read: Bool
}
