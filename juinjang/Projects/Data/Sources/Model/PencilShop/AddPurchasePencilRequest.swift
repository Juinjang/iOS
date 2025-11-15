import Foundation
import DomainModel

public struct AddPurchasePencilRequest: Codable {
    let transactionId: String
    let appAccountToken: String
    let pencilQuantity: Int
    let price: Int
    let productId: String
    let playTime: Int
    
    init(_ model: AddPurchasePencil) {
        transactionId = model.transactionId
        appAccountToken = model.appAccountToken
        pencilQuantity = model.pencilQuantity
        price = model.price
        productId = model.productId
        playTime = model.playTime
    }
}
