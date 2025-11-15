import Foundation

public struct NoteCheckListAnswer {
    let questionId: Int
    let answer: String
    
    public init(questionId: Int, answer: String) {
        self.questionId = questionId
        self.answer = answer
    }
}
