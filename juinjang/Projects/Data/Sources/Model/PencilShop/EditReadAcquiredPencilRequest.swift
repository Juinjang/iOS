import Foundation
import Domain

public struct EditReadAcquiredPencilRequest: Codable {
    let acquiredPencilId: Int
    
    init(_ model: EditReadAcquiredPencil) {
        acquiredPencilId = model.acquiredPencilId
    }
}
