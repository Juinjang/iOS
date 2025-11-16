import Foundation
import Core
import Domain

public struct SharedNoteSearchCompletedResultResponse: Codable, DomainMappable {
    let totalResults: Int
    let notes: [SharedNoteResponse]
    
    public func toDomain() -> SharedNoteSearchCompletedResult {
        return SharedNoteSearchCompletedResult.init(
            totalResults: totalResults,
            notes: notes.map { $0.toDomain() }
        )
    }
}
