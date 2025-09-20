import Foundation

public struct ShareableConditionDTO: Codable {
    let isTotalSatisfied: Bool
    let conditions: [ShareableCondition]
}


