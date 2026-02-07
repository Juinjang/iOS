//
//  PurchasedPencilDTO.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

struct PurchasedPencilDTO: Codable, Hashable {
    let purchasePencilId: Int
    let purchaseQuantity: Int
    let remainQuantity: Int?
    let title: String
    let price: Int
    let purchasedAt: String
}
