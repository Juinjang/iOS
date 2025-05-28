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

extension ShareableCondition {
    var categoryToKorean: String {
        switch self.category {
        case "LOCATION_CONDITION":
            return "입지"
        case "PUBLIC_SPACE":
            return "공용"
        case "INDOOR":
            return "실내"
        default:
            return ""
        }
    }
}
