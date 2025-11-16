//
//  PendingTransactionStore.swift
//  juinjang
//
//  Created by 조유진 on 5/4/25.
//

import Foundation

protocol PendingTransactionStoreProtocol {
    func save(_ pendingTransaction: PendingTransactionRequest)
    func loadAll() -> [PendingTransactionResponse]
    func remove(_ pendingTransaction: PendingTransactionRequest)
}

final class PendingTransactionStore: PendingTransactionStoreProtocol {
    static let shared = PendingTransactionStore()
    private let userDefault: UserDefaultManager

    private init(userDefault: UserDefaultManager = .shared) {
        self.userDefault = userDefault
    }
    
    func save(_ pendingTransaction: PendingTransactionRequest) {
        var list = loadAll()
        guard !list.contains(pendingTransaction) else { return }
        list.append(pendingTransaction)
        persist(list)
    }

    func loadAll() -> [PendingTransactionResponse] {
        guard let data = userDefault.pendingTansactions,
              let list = try? JSONDecoder().decode([PendingTransactionResponse].self, from: data) else {
            return []
        }
        return list
    }

    func remove(_ pendingTransaction: PendingTransactionRequest) {
        var list = loadAll()
        list.removeAll { $0 == pendingTransaction }
        persist(list)
    }

    private func persist(_ list: [PendingTransactionRequest]) {
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
