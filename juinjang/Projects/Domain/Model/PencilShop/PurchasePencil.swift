import Foundation

public struct PurchasePencil: Equatable {
    let status: String
    let transactionId: String
    let purchaseQuantity: Int
    let remainQuantity: Int?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.transactionId == rhs.transactionId
    }
    
    public init(status: String,
                transactionId: String,
                purchaseQuantity: Int,
                remainQuantity: Int?) {
        self.status = status
        self.transactionId = transactionId
        self.purchaseQuantity = purchaseQuantity
        self.remainQuantity = remainQuantity
    }
}
