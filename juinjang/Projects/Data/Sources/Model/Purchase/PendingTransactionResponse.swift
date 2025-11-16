import Foundation

struct PendingTransactionResponse: Codable {
    let jws: String
    let createdAt: Date
}
