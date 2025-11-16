import Foundation
import Core
import Domain

public struct NoteRecordResponse: Codable, DomainMappable {
    var recordName: String
    let createdAt: String
    let updatedAt: String
    var recordScript: String
    let recordTime: Int
    let recordUrl: String
    let recordId: Int
    let limjangId: Int
    
    public func toDomain() -> NoteRecord {
        return NoteRecord.init(
            recordName: recordName,
            createdAt: createdAt,
            updatedAt: updatedAt,
            recordScript: recordScript,
            recordTime: recordTime,
            recordUrl: recordUrl,
            recordId: recordId,
            limjangId: limjangId
        )
    }
}
