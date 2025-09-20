import Foundation

public struct ShareableCondition {
    let isTotalSatisfied: Bool
    let conditions: [ShareableCondition]
}


