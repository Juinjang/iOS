import Foundation
import Core
import Domain

public struct NoteResponse: Codable, DomainMappable {
    let noteId: Int
    let purposeType: String
    let propertyType: String
    let priceType: String
    let name: String
    let imageUrls: [String]
    var isScraped: Bool
    let rate: String?
    let price: String
    let monthlyRent: String?
    let pyong: Int?
    let floor: String?
    let address: String?
    let shortAddress: String?
    
    public func toDomain() -> MyNote {
        return MyNote.init(
            noteId: noteId,
            purposeType: purposeType,
            propertyType: propertyType,
            priceType: priceType,
            name: name,
            imageUrls: imageUrls,
            isScraped: isScraped,
            rate: rate,
            price: price,
            monthlyRent: monthlyRent,
            pyong: pyong,
            floor: floor,
            address: address,
            shortAddress: shortAddress
        )
    }
}
