import Foundation

public struct NoteAddCompleted {
    let limjangId: Int
    let createdAt: String
    
    public init(limjangId: Int,
                createdAt: String) {
        self.limjangId = limjangId
        self.createdAt = createdAt
    }
}
