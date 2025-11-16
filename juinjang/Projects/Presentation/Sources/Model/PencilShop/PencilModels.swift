//
//  PencilModels.swift
//  Scenes
//
//  Created by KimDongWoo on 10/12/25.
//

struct ObtainedPencilModel: Hashable {
    let id = UUID()
    let acquiredPencilId: Int
    let content: String
    let createdAt: String
    let acquiredQuantity: Int
    let isRead: Bool
    let type: String
    let sharedNoteId: Int
}

struct PurchasedPencilModel: Hashable {
    let id = UUID()
    let purchasedPencilId: Int
    let purchaseQuantity: Int
    let remainQuantity: Int
    let title: String
    let price: Int
    let createdAt: String
}


struct UsedPencilModel: Hashable {
    let id = UUID()
    let usedPencilId: Int
    let useQuantity: Int
    let type: String
    let remainQuantity: Int
    let buildingName: String
    let sharedNoteId: Int
    let createdAt: String
}
