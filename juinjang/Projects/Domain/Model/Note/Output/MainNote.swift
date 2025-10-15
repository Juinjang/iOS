import Foundation

public struct MainNote: Codable {
    let limjangId: Int
    let priceType: Int
    let image: String?
    let nickname: String
    let price: String
    let totalAverage: String?    // 체크리스트 생선 전일 경우 값은 nil
    let address: String?
    
    public init(limjangId: Int,
                priceType: Int,
                image: String?,
                nickname: String,
                price: String,
                totalAverage: String?,
                address: String?) {
        self.limjangId = limjangId
        self.priceType = priceType
        self.image = image
        self.nickname = nickname
        self.price = price
        self.totalAverage = totalAverage
        self.address = address
    }
}
