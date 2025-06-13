//
//  ImjangDetailReportModel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/10/25.
//

struct ImjangDetailReportModel: Codable {
    let indoorKeyword: String
    let publicSpaceKeyword: String
    let locationConditionsKeyword: String
    let indoorRate: Double
    let publicSpaceRate: Double
    let locationConditionsRate: Double
    let totalRate: Double
    
    enum CodingKeys: String, CodingKey {
        case indoorKeyword = "indoorKeyWord"
        case publicSpaceKeyword = "publicSpaceKeyWord"
        case locationConditionsKeyword = "locationConditionsWord"
        case indoorRate
        case publicSpaceRate
        case locationConditionsRate
        case totalRate
    }
}
