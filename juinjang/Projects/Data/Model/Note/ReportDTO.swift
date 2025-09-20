import Foundation

public struct ReportDTO: Codable {
    let reportId: Int
    let indoorKeyWord: String
    let publicSpaceKeyWord: String
    let locationConditionsWord: String
    let indoorRate: Float
    let publicSpaceRate: Float
    let locationConditionsRate: Float
    let totalRate: Float
}
