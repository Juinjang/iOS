//
//  UsedPencilDTO.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

public struct UsedPencil: Hashable {
    let usedPencilId: Int
    let useQuantity: Int
    let type: String
    let remainQuantity: Int
    let buildingName: String
    let sharedNoteId: Int
    let createdAt: String
}
