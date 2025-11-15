import Foundation

public struct ShareableNoteSelect {
    let noteId: Int
    let purposeType: String
    let propertyType: String
    let priceType: String
    let name: String
    let imageUrl: String?
    let isScraped: Bool
    let rate: String?
    let price: String
    let monthlyRent: String?
    let pyong: Int
    let floor: String
    let shortAddress: String
    var rewardPencil: Int?
    
    public init(noteId: Int,
                purposeType: String,
                propertyType: String,
                priceType: String,
                name: String,
                imageUrl: String?,
                isScraped: Bool,
                rate: String?,
                price: String,
                monthlyRent: String?,
                pyong: Int,
                floor: String,
                shortAddress: String,
                rewardPencil: Int?) {
        self.noteId = noteId
        self.purposeType = purposeType
        self.propertyType = propertyType
        self.priceType = priceType
        self.name = name
        self.imageUrl = imageUrl
        self.isScraped = isScraped
        self.rate = rate
        self.price = price
        self.monthlyRent = monthlyRent
        self.pyong = pyong
        self.floor = floor
        self.shortAddress = shortAddress
        self.rewardPencil = rewardPencil
    }
}
