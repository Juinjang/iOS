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
}
