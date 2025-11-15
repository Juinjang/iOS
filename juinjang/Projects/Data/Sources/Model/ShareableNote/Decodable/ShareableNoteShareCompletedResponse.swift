import Foundation
import CoreCommon
import DomainModel

public struct ShareableNoteShareCompletedResponse: Codable, DomainMappable {
    let sharedNoteId: Int
    
    public func toDomain() -> ShareableNoteShareCompleted {
        return ShareableNoteShareCompleted.init(sharedNoteId: sharedNoteId)
    }
}
