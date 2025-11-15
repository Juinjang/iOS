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
    
    public init(acquiredPencilId: Int,
                content: String,
                sharedNoteId: Int,
                acquiredQuantity: Int,
                buildingName: String,
                type: String,
                createdAt: String,
                read: Bool) {
        self.acquiredPencilId = acquiredPencilId
        self.content = content
        self.sharedNoteId = sharedNoteId
        self.acquiredQuantity = acquiredQuantity
        self.buildingName = buildingName
        self.type = type
        self.createdAt = createdAt
        self.read = read
    }
}
