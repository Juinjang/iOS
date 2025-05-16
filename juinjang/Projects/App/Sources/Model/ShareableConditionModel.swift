//
//  ShareableConditionModel.swift
//  juinjang
//
//  Created by KimDongWoo on 5/14/25.
//

struct ShareableCondition: Codable {
    let category: String
    let answeredCount: Int
    let totalCount: Int
    let requiredCount: Int
    let isSatisfied: Bool
}
