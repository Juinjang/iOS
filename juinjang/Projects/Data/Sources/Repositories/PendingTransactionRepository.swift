//
//  PendingTransactionRepository.swift
//  Data
//
//  Created by KimDongWoo on 11/16/25.
//

import Foundation
import Domain

final class PendingTransactionRepository: PendingTransactionRepositoryProtocol {
    private let store: PendingTransactionStoreProtocol

    init(store: PendingTransactionStoreProtocol = PendingTransactionStore.shared) {
        self.store = store
    }

    func save(_ transaction: PendingTransaction) {
        let dto = PendingTransactionRequest(jws: transaction.jws, createdAt: transaction.createdAt)
        store.save(dto)
    }

    func loadAll() -> [PendingTransaction] {
        return store
            .loadAll()
            .map { PendingTransaction(jws: $0.jws, createdAt: $0.createdAt) }
    }

    func remove(_ transaction: PendingTransaction) {
        let dto = PendingTransactionRequest(jws: transaction.jws, createdAt: transaction.createdAt)
        store.remove(dto)
    }
}
