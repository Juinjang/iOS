import Foundation

public struct Note {
    public let noteId: Int
    public let purposeType: String
    public let propertyType: String
    public let priceType: String
    public let name: String
    public let imageUrl: [String]
    public var isScraped: Bool
    public let rate: String?
    public let price: String
    public let monthlyRent: String?
    public let pyong: Int?
    public let floor: String?
    public let shortAddress: String?
    public let address: String?
    
    public init(noteId: Int,
                purposeType: String,
                propertyType: String,
                priceType: String,
                name: String,
                imageUrl: [String],
                isScraped: Bool,
                rate: String?,
                price: String,
                monthlyRent: String?,
                pyong: Int?,
                floor: String?,
                shortAddress: String?,
                address: String?) {
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
        self.address = address
    }
}
