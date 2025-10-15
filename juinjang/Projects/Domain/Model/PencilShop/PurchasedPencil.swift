import Foundation

public struct PurchasedPencil {
    let purchasePencilId: Int
    let purchaseQuantity: Int
    let remainQuantity: Int?
    let title: String
    let price: Int
    let purchasedAt: String
    
    public init(purchasePencilId: Int,
                purchaseQuantity: Int,
                remainQuantity: Int?,
                title: String,
                price: Int,
                purchasedAt: String) {
        self.purchasePencilId = purchasePencilId
        self.purchaseQuantity = purchaseQuantity
        self.remainQuantity = remainQuantity
        self.title = title
        self.price = price
        self.purchasedAt = purchasedAt
    }
}
