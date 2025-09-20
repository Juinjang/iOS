import Foundation

public struct reportDto: Codable {
    let reportDTO: ReportDTO
    let limjangDto: DetailDto
}

public struct Report {
    let reportId: Int
    let indoorKeyWord: String
    let publicSpaceKeyWord: String
    let locationConditionsWord: String
    let indoorRate: Float
    let publicSpaceRate: Float
    let locationConditionsRate: Float
    let totalRate: Float
}
