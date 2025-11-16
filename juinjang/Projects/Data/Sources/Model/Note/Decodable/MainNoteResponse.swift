import Foundation
import Core
import Domain

public struct MainNoteResponse: Codable, DomainMappable {
    let limjangId: Int
    let priceType: Int
    let image: String?
    let nickname: String
    let price: String
    let totalAverage: String?    // 체크리스트 생선 전일 경우 값은 nil
    let address: String?
    
    public func toDomain() -> MainNote {
        return MainNote.init(
            limjangId: limjangId,
            priceType: priceType,
            image: image,
            nickname: nickname,
            price: price,
            totalAverage: totalAverage,
            address: address
        )
    }
}
