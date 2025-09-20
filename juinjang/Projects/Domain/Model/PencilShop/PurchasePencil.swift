//
//  PurchasePencil.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

public struct PurchasePencil: Equatable {
    let status: String
    let transactionId: String
    let purchaseQuantity: Int
    let remainQuantity: Int?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.transactionId == rhs.transactionId
    }
}
