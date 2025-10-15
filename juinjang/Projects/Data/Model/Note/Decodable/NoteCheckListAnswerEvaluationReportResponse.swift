import Foundation
import CoreCommon
import DomainModel

public struct NoteCheckListAnswerEvaluationReportResponse: Codable, DomainMappable {
    let answerDtoList: [NoteCheckListAnswerResponse]
    let reportDto: NoteEvaluationReportResultResponse
    
    public func toDomain() -> NoteCheckListAnswerEvaluationReport {
        return NoteCheckListAnswerEvaluationReport.init(
            answerList: answerDtoList,
            report: reportDto
        )
    }
}
