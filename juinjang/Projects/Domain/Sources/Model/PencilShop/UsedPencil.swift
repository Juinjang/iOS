import Foundation

public struct UsedPencil: Hashable {
    let usedPencilId: Int
    let useQuantity: Int
    let type: String
    let remainQuantity: Int
    let buildingName: String
    let sharedNoteId: Int
    let createdAt: String
    
    public init(usedPencilId: Int,
                useQuantity: Int,
                type: String,
                remainQuantity: Int,
                buildingName: String,
                sharedNoteId: Int,
                createdAt: String) {
        self.usedPencilId = usedPencilId
        self.useQuantity = useQuantity
        self.type = type
        self.remainQuantity = remainQuantity
        self.buildingName = buildingName
        self.sharedNoteId = sharedNoteId
        self.createdAt = createdAt
    }
}
