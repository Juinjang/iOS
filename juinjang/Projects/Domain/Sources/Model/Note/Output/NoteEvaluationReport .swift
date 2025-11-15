import Foundation

public struct NoteEvaluationReport {
    let reportId: Int
    let indoorKeyWord: String
    let publicSpaceKeyWord: String
    let locationConditionsWord: String
    let indoorRate: Float
    let publicSpaceRate: Float
    let locationConditionsRate: Float
    let totalRate: Float
    
    public init(reportId: Int,
                indoorKeyWord: String,
                publicSpaceKeyWord: String,
                locationConditionsWord: String,
                indoorRate: Float,
                publicSpaceRate: Float,
                locationConditionsRate: Float,
                totalRate: Float) {
        self.reportId = reportId
        self.indoorKeyWord = indoorKeyWord
        self.publicSpaceKeyWord = publicSpaceKeyWord
        self.locationConditionsWord = locationConditionsWord
        self.indoorRate = indoorRate
        self.publicSpaceRate = publicSpaceRate
        self.locationConditionsRate = locationConditionsRate
        self.totalRate = totalRate
    }
}
