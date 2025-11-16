import Foundation
import Core
import Domain

public struct PurchasedPencilResponse: Codable, Hashable, DomainMappable {
    let purchasePencilId: Int
    let purchaseQuantity: Int
    let remainQuantity: Int?
    let title: String
    let price: Int
    let purchasedAt: String
    
    public func toDomain() -> PurchasedPencil {
        return PurchasedPencil.init(
            purchasePencilId: purchasePencilId,
            purchaseQuantity: purchaseQuantity,
            remainQuantity: remainQuantity,
            title: title,
            price: price,
            purchasedAt: purchasedAt
        )
    }
}
