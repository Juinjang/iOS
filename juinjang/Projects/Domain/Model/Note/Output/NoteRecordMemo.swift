import Foundation

public struct NoteRecordMemo {
    let limjangId: Int
    let memo: String?
    let createdAt: String
    let updatedAt: String
    let recordDto: [Record]
    
    public init(limjangId: Int,
                memo: String?,
                createdAt: String,
                updatedAt: String,
                recordDto: [Record]) {
        self.limjangId = limjangId
        self.memo = memo
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.recordDto = recordDto
    }
}
