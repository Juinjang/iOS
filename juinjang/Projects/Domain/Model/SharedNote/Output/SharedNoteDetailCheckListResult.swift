import Foundation

public struct SharedNoteDetailCheckListResult {
    let checklistAnswers: [SharedNoteDetailCheckListAnswer]
    let review: String?
    let totalRate: Double?
    
    public init(checklistAnswers: [SharedNoteDetailCheckListAnswer],
                review: String?,
                totalRate: Double?) {
        self.checklistAnswers = checklistAnswers
        self.review = review
        self.totalRate = totalRate
    }
}
