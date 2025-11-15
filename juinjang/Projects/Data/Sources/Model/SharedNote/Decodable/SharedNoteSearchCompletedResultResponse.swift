import Foundation
import CoreCommon
import DomainModel

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
