import Foundation
import Core
import Domain

public struct NoteCheckListAnswerStatsResponse: Codable, DomainMappable {
    let answerDtoList: [NoteCheckListAnswerResponse]
    let reportDto: NoteStatsResultResponse
    
    public func toDomain() -> NoteCheckListAnswerEvaluationReport {
        return NoteCheckListAnswerEvaluationReport.init(
            answerList: answerDtoList,
            report: reportDto
        )
    }
}
