//
//  PendingTransaction.swift
//  Domain
//
//  Created by KimDongWoo on 11/16/25.
//

import Foundation

public struct PendingTransaction: Equatable {
    public let jws: String
    public let createdAt: Date

    public init(jws: String, createdAt: Date) {
        self.jws = jws
        self.createdAt = createdAt
    }
}
