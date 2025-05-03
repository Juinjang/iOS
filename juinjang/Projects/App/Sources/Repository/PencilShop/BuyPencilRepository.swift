//
//  BuyPencilRepository.swift
//  juinjang
//
//  Created by 조유진 on 4/6/25.
//

import RxSwift
import Foundation
import StoreKit

protocol BuyPencilRepositoryProtocol {
    func verifyTransaction(transaction: Transaction) async throws -> VerifiyTransactionResponse
}

final class MockBuyPencilRepository: BuyPencilRepositoryProtocol {
    func verifyTransaction(transaction: Transaction) async throws -> VerifiyTransactionResponse {
        return .mock
    }
}

extension VerifiyTransactionResponse {
    static let mock: VerifiyTransactionResponse = VerifiyTransactionResponse(isSuccess: true, pencilCount: 12)
}

struct VerifiyTransactionResponse: Codable {
    let isSuccess: Bool
    let pencilCount: Int
}
