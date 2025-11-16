import Foundation
import Core
import Domain

public struct AcquiredPencilResponse: Codable, Hashable {
    let acquiredPencilId: Int
    let content: String
    let sharedNoteId: Int
    let acquiredQuantity: Int
    let buildingName: String
    let type: String
    let createdAt: String
    var read: Bool
    
    public func toDomain() -> AcquiredPencil {
        return AcquiredPencil.init(
            acquiredPencilId: acquiredPencilId,
            content: content,
            sharedNoteId: sharedNoteId,
            acquiredQuantity: acquiredQuantity,
            buildingName: buildingName,
            type: type,
            createdAt: createdAt,
            read: read
        )
    }
}
