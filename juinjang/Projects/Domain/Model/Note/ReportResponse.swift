//
//  ReportResponse.swift
//  Domain
//
//  Created by KimDongWoo on 9/20/25.
//

public struct ReportResponseDto: Codable {
    let reportDTO: Report
    let limjangDto: DetailDto
}
