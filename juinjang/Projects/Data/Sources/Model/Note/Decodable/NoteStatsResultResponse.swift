import Foundation
import CoreCommon
import DomainModel

public struct NoteStatsResultResponse: Codable, DomainMappable {
    let reportDTO: NoteEvaluationReportResponse
    let limjangDto: NoteDetailResponse
    
    public func toDomain() -> NoteEvaluationReportResult {
        return NoteEvaluationReportResult.init(
            report: reportDTO.toDomain(),
            noteDetail: limjangDto.toDomain()
        )
    }
}
