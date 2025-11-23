//
//  CheckListResponseDto.swift
//  juinjang
//
//  Created by 임수진 on 2/15/24.
//

struct CheckListReportResult: Codable {
    let answerDtoList: [CheckListAnswerDTO]
    let reportDto: ReportDtoWrapper
}

struct CheckListAnswerDTO: Codable {
    let questionId: Int
    let answer: String
}

struct ReportDtoWrapper: Codable {
    let reportDTO: ReportDTO
    let limjangDto: DetailDto
}

