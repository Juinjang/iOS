import Foundation

public struct ResultDTO: Codable {
    let answerDtoList: [AnswerDto]
    let reportDto: ReportDTO
}
