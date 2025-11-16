import Foundation
import Core
import Domain

public struct SharedNoteDetailCheckListResultResponse: Codable, DomainMappable {
    let checklistAnswers: [SharedNoteCheckListAnswerResponse]
    let review: String?
    let totalRate: Double?
    
    public func toDomain() -> SharedNoteDetailCheckListResult {
        return SharedNoteDetailCheckListResult.init(
            checklistAnswers: checklistAnswers,
            review: review,
            totalRate: totalRate
        )
    }
}
