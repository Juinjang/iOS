import Foundation
import CoreCommon
import DomainModel

struct SharedNoteResponse: Codable, DomainMappable {
    let sharedNoteId: Int
    let propertyType: String
    let priceType: String
    let buildingName: String
    let imageUrl: String?
    let isPurchase: Bool
    var isLiked: Bool
    let rate: String?
    let price: String
    let monthlyRent: String?
    let pyong: Int?
    let floor: String?
    let address: String
    let ownerImageUrl: String?
    let ownerNickname: String
    let timeAge: String?
    let viewCount: Int
    
    public func toDomain() -> SharedNote {
        return SharedNote.init(
            sharedNoteId: sharedNoteId,
            propertyType: propertyType,
            priceType: priceType,
            buildingName: buildingName,
            imageUrl: imageUrl,
            isPurchase: isPurchase,
            isLiked: isLiked,
            rate: rate,
            price: price,
            monthlyRent: monthlyRent,
            pyong: pyong,
            floor: floor,
            address: address,
            ownerImageUrl: ownerImageUrl,
            ownerNickname: ownerNickname,
            timeAge: timeAge,
            viewCount: viewCount
        )
    }
}

