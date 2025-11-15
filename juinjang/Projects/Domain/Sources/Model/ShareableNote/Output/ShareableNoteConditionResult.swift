import Foundation

public struct ShareableNoteConditionResult {
    let isTotalSatisfied: Bool
    let conditions: [ShareableNoteCondition]
    
    public init(isTotalSatisfied: Bool, conditions: [ShareableNoteCondition]) {
        self.isTotalSatisfied = isTotalSatisfied
        self.conditions = conditions
    }
}


