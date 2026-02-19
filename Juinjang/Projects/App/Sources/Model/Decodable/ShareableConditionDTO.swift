//
//  ShareableConditionDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 5/14/25.
//

struct ShareableConditionDTO: Codable {
    let isTotalSatisfied: Bool
    let conditions: [ShareableCondition]
}
