import Foundation
import Domain

public struct AddSharedNoteReportRequest: Encodable {
    let sharedNoteId: Int
    let type: String
    
    init(_ model: AddSharedNoteReport) {
        sharedNoteId = model.sharedNoteId
        type = model.type
    }
}
