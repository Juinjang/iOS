import Foundation
import DomainModel

public struct EditReadAcquiredPencilRequest: Codable {
    let acquiredPencilId: Int
    
    init(_ model: EditReadAcquiredPencil) {
        acquiredPencilId = model.acquiredPencilId
    }
}
