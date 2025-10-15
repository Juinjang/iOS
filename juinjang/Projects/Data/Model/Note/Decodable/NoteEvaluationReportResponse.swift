import Foundation
import CoreCommon
import DomainModel

public struct NoteEvaluationReportResponse: Codable, DomainMappable {
    let reportId: Int
    let indoorKeyWord: String
    let publicSpaceKeyWord: String
    let locationConditionsWord: String
    let indoorRate: Float
    let publicSpaceRate: Float
    let locationConditionsRate: Float
    let totalRate: Float
    
    public func toDomain() -> NoteEvaluationReport {
        return NoteEvaluationReport.init(
            reportId: reportId,
            indoorKeyWord: indoorKeyWord,
            publicSpaceKeyWord: publicSpaceKeyWord,
            locationConditionsWord: locationConditionsWord,
            indoorRate: indoorRate,
            publicSpaceRate: publicSpaceRate,
            locationConditionsRate: locationConditionsRate,
            totalRate: totalRate
        )
    }
}
