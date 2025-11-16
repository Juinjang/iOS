import Foundation

public protocol PendingTransactionRepositoryProtocol {
    func save(_ transaction: PendingTransaction)
    func loadAll() -> [PendingTransaction]
    func remove(_ transaction: PendingTransaction)
}
