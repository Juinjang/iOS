import Foundation

public struct AcquiredPencil: Hashable {
    let acquiredPencilId: Int
    let content: String
    let sharedNoteId: Int
    let acquiredQuantity: Int
    let buildingName: String
    let type: String
    let createdAt: String
    var read: Bool
}
