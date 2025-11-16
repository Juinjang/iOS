import Foundation
import Core
import Domain

public struct ShareableNoteShareCompletedResponse: Codable, DomainMappable {
    let sharedNoteId: Int
    
    public func toDomain() -> ShareableNoteShareCompleted {
        return ShareableNoteShareCompleted.init(sharedNoteId: sharedNoteId)
    }
}
