import Foundation

public struct PurchasedPencilDTO: Codable, Hashable {
    let purchasePencilId: Int
    let purchaseQuantity: Int
    let remainQuantity: Int?
    let title: String
    let price: Int
    let purchasedAt: String
}
