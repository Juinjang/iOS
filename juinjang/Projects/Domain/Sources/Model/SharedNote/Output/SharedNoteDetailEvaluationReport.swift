import Foundation

public struct SharedNoteDetailEvaluationReport: Codable {
    let indoorKeyword: String
    let publicSpaceKeyword: String
    let locationConditionsKeyword: String
    let indoorRate: Double
    let publicSpaceRate: Double
    let locationConditionsRate: Double
    let totalRate: Double
    
    init(indoorKeyword: String,
         publicSpaceKeyword: String,
         locationConditionsKeyword: String,
         indoorRate: Double,
         publicSpaceRate: Double,
         locationConditionsRate: Double,
         totalRate: Double) {
        self.indoorKeyword = indoorKeyword
        self.publicSpaceKeyword = publicSpaceKeyword
        self.locationConditionsKeyword = locationConditionsKeyword
        self.indoorRate = indoorRate
        self.publicSpaceRate = publicSpaceRate
        self.locationConditionsRate = locationConditionsRate
        self.totalRate = totalRate
    }
}
