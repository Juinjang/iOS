import Foundation
import Core
import Domain

public struct PurchasePencilResponse: Codable, DomainMappable {
    let status: String
    let transactionId: String
    let purchaseQuantity: Int
    let remainQuantity: Int?
    
    public func toDomain() -> PurchasePencil {
        return PurchasePencil.init(
            status: status,
            transactionId: transactionId,
            purchaseQuantity: purchaseQuantity,
            remainQuantity: remainQuantity
        )
    }
}
