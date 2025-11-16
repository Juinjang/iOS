import Foundation
import Core
import Domain

struct SharedNoteCheckListAnswerResponse: Codable, DomainMappable {
    let answerId: Int
    let questionId: Int
    let category: String?
    let limjangId: Int?
    let answer: String?
    let answerType: String?
    
    public func toDomain() -> SharedNoteDetailCheckListAnswer {
        return SharedNoteDetailCheckListAnswer.init(
            answerId: answerId,
            questionId: questionId,
            category: category,
            limjangId: limjangId,
            answer: answer,
            answerType: answerType
        )
    }
}
