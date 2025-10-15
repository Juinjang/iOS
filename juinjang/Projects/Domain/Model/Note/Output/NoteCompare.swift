import Foundation

public struct NoteCompare: Hashable {
    var id: UUID
    let limjangId: Int
    let images: [String]
    let purposeCode: Int        // 거래목적
    var isScraped: Bool
    let nickname: String
    let priceType: Int
    let priceList: [String]
    let totalAverage: String?    // 체크리스트 생선 전일 경우 값은 nil
    let address: String?
    
    public init(id: UUID = UUID(),
                limjangId: Int,
                images: [String],
                purposeCode: Int,
                isScraped: Bool,
                nickname: String,
                priceType: Int,
                priceList: [String],
                totalAverage: String?,
                address: String?) {
        self.id = id
        self.limjangId = limjangId
        self.images = images
        self.purposeCode = purposeCode
        self.isScraped = isScraped
        self.nickname = nickname
        self.priceType = priceType
        self.priceList = priceList
        self.totalAverage = totalAverage
        self.address = address
    }
}
