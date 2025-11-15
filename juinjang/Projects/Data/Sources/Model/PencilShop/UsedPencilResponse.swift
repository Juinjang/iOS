import Foundation
import CoreCommon
import DomainModel

public struct UsedPencilResponse: Codable, DomainMappable {
    let usedPencilId: Int
    let useQuantity: Int
    let type: String
    let remainQuantity: Int
    let buildingName: String
    let sharedNoteId: Int
    let createdAt: String
    
    public func toDomain() -> UsedPencil {
        return UsedPencil.init(
            usedPencilId: usedPencilId,
            useQuantity: useQuantity,
            type: type,
            remainQuantity: remainQuantity,
            buildingName: buildingName,
            sharedNoteId: sharedNoteId,
            createdAt: createdAt
        )
    }
}
