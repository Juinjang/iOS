import Foundation
import Domain

public struct AddRecordRequestDTO: Codable {
    var limjangId: Int
    var recordTime: Int
    var recordScript: String
    
    init(_ model: AddNoteRecord) {
        limjangId = model.limjangId
        recordTime = model.recordTime
        recordScript = model.recordScript
    }
}
