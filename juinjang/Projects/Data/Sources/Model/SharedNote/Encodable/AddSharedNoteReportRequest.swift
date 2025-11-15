import Foundation
import DomainModel

public struct AddSharedNoteReportRequest: Encodable {
    let sharedNoteId: Int
    let type: String
    
    init(_ model: AddSharedNoteReport) {
        sharedNoteId = model.sharedNoteId
        type = model.type
    }
}
