import Foundation
import CoreCommon
import DomainModel

public struct RecentUpdatedNoteResultResponse: Codable, DomainMappable {
    let recentUpdatedList: [NoteResponse]
    
    public func toDomain() -> RecentUpdatedNoteResult {
        return RecentUpdatedNoteResult.init(
            recentUpdatedList: recentUpdatedList.map { $0.toDomain() }
        )
    }
}
