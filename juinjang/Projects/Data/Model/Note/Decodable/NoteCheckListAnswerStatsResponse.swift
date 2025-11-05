import Foundation
import CoreCommon
import DomainModel

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
