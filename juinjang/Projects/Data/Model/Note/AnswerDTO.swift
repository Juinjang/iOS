import Foundation

public struct AnswerDTO: Codable {
    let answerId: Int
    let questionId: Int
    let category: String
    let limjangId: Int
    let answer: String
    let answerType: String
}
