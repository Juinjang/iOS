import Foundation
import Core
import Domain

public struct NoteResultResponse: Codable, DomainMappable {
    let notes: [NoteResponse]
    
    public func toDomain() -> NoteResult {
        return NoteResult.init(notes: notes.map { $0.toDomain() })
    }
}
