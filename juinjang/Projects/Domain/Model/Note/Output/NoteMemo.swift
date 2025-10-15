import Foundation

public struct NoteMemo {
    let limjangId: Int
    let createdAt: String
    let updatedAt: String
    let memo: String?
    
    public init(limjangId: Int,
                createdAt: String,
                updatedAt: String,
                memo: String?) {
        self.limjangId = limjangId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.memo = memo
    }
}
