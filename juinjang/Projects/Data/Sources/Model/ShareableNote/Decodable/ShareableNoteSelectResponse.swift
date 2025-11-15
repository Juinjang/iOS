import Foundation
import CoreCommon
import DomainModel

struct ShareableNoteSelectResponse: Codable, DomainMappable {
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
    let rewardPencil: Int?
    
    public func toDomain() -> ShareableNoteSelect {
        return ShareableNoteSelect.init(
            noteId: noteId,
            purposeType: purposeType,
            propertyType: propertyType,
            priceType: priceType,
            name: name,
            imageUrl: imageUrl,
            isScraped: isScraped,
            rate: rate,
            price: price,
            monthlyRent: monthlyRent,
            pyong: pyong,
            floor: floor,
            shortAddress: shortAddress,
            rewardPencil: rewardPencil
        )
    }
}
