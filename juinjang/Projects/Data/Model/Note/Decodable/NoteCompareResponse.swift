import Foundation
import CoreCommon
import DomainModel

public struct NoteCompareResponse: Codable, DomainMappable {
    let limjangId: Int
    let images: [String]
    let purposeCode: Int        // 거래목적
    var isScraped: Bool
    let nickname: String
    let priceType: Int
    let priceList: [String]
    let totalAverage: String?    // 체크리스트 생선 전일 경우 값은 nil
    let address: String?
    
    public func toDomain() -> NoteCompare {
        return NoteCompare.init(
            limjangId: limjangId,
            images: images,
            purposeCode: purposeCode,
            isScraped: isScraped,
            nickname: nickname,
            priceType: priceType,
            priceList: priceList,
            totalAverage: totalAverage,
            address: address
        )
    }
}
