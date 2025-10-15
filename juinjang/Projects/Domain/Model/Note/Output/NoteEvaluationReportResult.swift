import Foundation

public struct NoteEvaluationReportResult {
    let report: NoteEvaluationReport
    let noteDetail: NoteDetail
    
    public init(report: NoteEvaluationReport,
                noteDetail: NoteDetail) {
        self.report = report
        self.noteDetail = noteDetail
    }
}
