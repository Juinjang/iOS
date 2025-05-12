//
//  BuyPencilRepository.swift
//  juinjang
//
//  Created by 조유진 on 4/6/25.
//

import RxSwift
import Foundation
import StoreKit

protocol VerifyTransactionRepositoryProtocol {
    func verifyTransaction(transaction: Transaction) async throws -> VerifiyTransactionResponse
}

final class MockVerifyTransactionRepository: VerifyTransactionRepositoryProtocol {
    func verifyTransaction(transaction: Transaction) async throws -> VerifiyTransactionResponse {
        return .mock
    }
}

extension VerifiyTransactionResponse {
    static let mock: VerifiyTransactionResponse = VerifiyTransactionResponse(
        isSuccess: true,
        currentPencilCount: 12,
        purchasedPencilCount: 3,
        transactionId: "asdf"
    )
}

struct VerifiyTransactionResponse: Codable, Equatable {
    let isSuccess: Bool
    let currentPencilCount: Int
    let purchasedPencilCount: Int
    let transactionId: String
}
