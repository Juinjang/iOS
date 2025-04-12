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
}
