import Foundation
import Core
import Domain

public struct ShareableNoteConditionResultResponse: Codable, DomainMappable {
    let isTotalSatisfied: Bool
    let conditions: [ShareableNoteConditionResponse]
    
    public func toDomain() -> ShareableNoteConditionResult {
        return ShareableNoteConditionResult.init(
            isTotalSatisfied: isTotalSatisfied,
            conditions: conditions
        )
    }
}
