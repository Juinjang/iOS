//
//  PurchasePencilRequestDTO.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

public struct PurchasePencilRequest {
    let transactionId: String
    let appAccountToken: String
    let pencilQuantity: Int
    let price: Int
    let productId: String
    let playTime: Int
}
