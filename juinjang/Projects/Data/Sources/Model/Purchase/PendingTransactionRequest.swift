import Foundation

struct PendingTransactionRequest: Codable, Equatable {
    let jws: String
    let createdAt: Date
}
