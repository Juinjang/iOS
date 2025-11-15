import Foundation

public struct ShareableNoteCondition: Codable {
    let category: String
    let answeredCount: Int
    let totalCount: Int
    let requiredCount: Int
    let isSatisfied: Bool
    
    public init(category: String,
                answeredCount: Int,
                totalCount: Int,
                requiredCount: Int,
                isSatisfied: Bool) {
        self.category = category
        self.answeredCount = answeredCount
        self.totalCount = totalCount
        self.requiredCount = requiredCount
        self.isSatisfied = isSatisfied
    }
}

extension ShareableNoteCondition {
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
