//
//  PendingTransactionStore.swift
//  juinjang
//
//  Created by 조유진 on 5/4/25.
//

import Foundation

struct PendingTransaction: Codable, Equatable {
    let jws: String
    let createdAt: Date
}

final class PendingTransactionStore {
    static let shared = PendingTransactionStore()
    private let key = "pending_transactions"

    private init() { }
    
    func save(_ pendingTransaction: PendingTransaction) {
        var list = loadAll()
        guard !list.contains(pendingTransaction) else { return }
        list.append(pendingTransaction)
        persist(list)
    }

    func loadAll() -> [PendingTransaction] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let list = try? JSONDecoder().decode([PendingTransaction].self, from: data) else {
            return []
        }
        return list
    }

    func remove(_ pendingTransaction: PendingTransaction) {
        var list = loadAll()
        list.removeAll { $0 == pendingTransaction }
        persist(list)
    }

    private func persist(_ list: [PendingTransaction]) {
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
