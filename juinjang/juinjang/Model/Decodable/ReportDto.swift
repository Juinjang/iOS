//
//  ReportDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct ResultDto: Codable {
    let answerDtoList: [AnswerDto]
    let reportDto: reportDto
}

struct AnswerDto: Codable {
    let answerId: Int
    let questionId: Int
    let category: String
    let limjangId: Int
    let answer: String
    let answerType: String
}

struct reportDto: Codable {
    let reportDTO: ReportDTO
    let limjangDto: DetailDto
}

struct ReportDTO: Codable {
    let reportId: Int
    let indoorKeyword: String
    let publicSpaceKeyWord: String
    let locationConditionsWord: String
    let indoorRate: Float
    let publicSpaceRate: Float
    let locationConditionsRate: Float
    let totalRate: Float
}


