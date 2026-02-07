//
//  PurchasePencilDTO.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

struct PurchasePencilDTO: Codable, Equatable {
    let status: String
    let transactionId: String
    let purchaseQuantity: Int
    let remainQuantity: Int?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.transactionId == rhs.transactionId
    }
}
