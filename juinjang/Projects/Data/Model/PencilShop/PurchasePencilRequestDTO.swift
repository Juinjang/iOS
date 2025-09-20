import Foundation

public struct PurchasePencilRequestDTO: Encodable {
    let transactionId: String
    let appAccountToken: String
    let pencilQuantity: Int
    let price: Int
    let productId: String
    let playTime: Int
}
