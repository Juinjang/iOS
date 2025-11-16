import Foundation
import Core
import Domain

struct ShareableNoteConditionResponse: Codable, DomainMappable {
    let category: String
    let answeredCount: Int
    let totalCount: Int
    let requiredCount: Int
    let isSatisfied: Bool
    
    public func toDomain() -> ShareableNoteCondition {
        return ShareableNoteCondition.init(
            category: category,
            answeredCount: answeredCount,
            totalCount: totalCount,
            requiredCount: requiredCount,
            isSatisfied: isSatisfied
        )
    }
}
