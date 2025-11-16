import Foundation
import Core
import Domain

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
