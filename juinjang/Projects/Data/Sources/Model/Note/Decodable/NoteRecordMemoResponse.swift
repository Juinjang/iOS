import Foundation
import Core
import Domain

public struct NoteRecordMemoResponse: Codable, DomainMappable {
    let limjangId: Int
    let memo: String?
    let createdAt: String
    let updatedAt: String
    let recordDto: [NoteRecordResponse]
    
    public func toDomain() -> NoteRecordMemo {
        return NoteRecordMemo.init(
            limjangId: limjangId,
            memo: memo,
            createdAt: createdAt,
            updatedAt: updatedAt,
            recordDto: recordDto.map { $0.toDomain() }
        )
    }
}
