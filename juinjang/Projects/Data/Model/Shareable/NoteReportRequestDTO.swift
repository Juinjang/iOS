import Foundation

public struct NoteReportRequestDTO: Encodable {
    let sharedNoteId: Int
    let type: String
}
