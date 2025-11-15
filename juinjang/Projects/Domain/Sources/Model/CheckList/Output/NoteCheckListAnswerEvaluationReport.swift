import Foundation

public struct NoteCheckListAnswerEvaluationReport {
    let answerList: [NoteCheckListAnswer]
    let report: NoteEvaluationReport
    
    public init(answerList: [NoteCheckListAnswer],
                report: NoteEvaluationReport) {
        self.answerList = answerList
        self.report = report
    }
}
