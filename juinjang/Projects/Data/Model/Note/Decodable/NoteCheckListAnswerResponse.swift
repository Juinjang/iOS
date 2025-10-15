import Foundation
import CoreCommon
import DomainModel

public struct NoteCheckListAnswerResponse: Codable, DomainMappable {
    let questionId: Int
    let answer: String
    
    public func toDomain() -> NoteCheckListAnswer {
        return NoteCheckListAnswer.init(
            questionId: questionId,
            answer: answer
        )
    }
}
