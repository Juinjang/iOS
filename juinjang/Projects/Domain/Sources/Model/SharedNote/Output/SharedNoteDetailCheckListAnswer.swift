import Foundation

struct SharedNoteDetailCheckListAnswer {
    let answerId: Int
    let questionId: Int
    let category: String?
    let limjangId: Int?
    let answer: String?
    let answerType: String?
    
    public init(answerId: Int,
                questionId: Int,
                category: String?,
                limjangId: Int?,
                answer: String?,
                answerType: String?) {
        self.answerId = answerId
        self.questionId = questionId
        self.category = category
        self.limjangId = limjangId
        self.answer = answer
        self.answerType = answerType
    }
}
