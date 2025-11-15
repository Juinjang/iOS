import Foundation

public struct NoteRecord {
    var recordName: String
    let createdAt: String
    let updatedAt: String
    var recordScript: String
    let recordTime: Int
    let recordUrl: String
    let recordId: Int
    let limjangId: Int
    
    public init(recordName: String,
                createdAt: String,
                updatedAt: String,
                recordScript: String,
                recordTime: Int,
                recordUrl: String,
                recordId: Int,
                limjangId: Int) {
        self.recordName = recordName
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.recordScript = recordScript
        self.recordTime = recordTime
        self.recordUrl = recordUrl
        self.recordId = recordId
        self.limjangId = limjangId
    }
}
