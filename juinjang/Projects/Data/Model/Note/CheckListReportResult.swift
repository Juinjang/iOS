import Foundation

public struct CheckListReportResult: Codable {
    let answerDtoList: [CheckListAnswerDTO]
    let reportDto: ReportDTOWrapper
}
