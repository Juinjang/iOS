//
//  Report.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

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
