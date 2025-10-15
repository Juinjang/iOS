import Foundation
import CoreCommon
import DomainModel

public struct NoteAddCompletedResponse: Codable, DomainMappable {
    let limjangId: Int
    let createdAt: String
    
    public func toDomain() -> NoteAddCompleted {
        return NoteAddCompleted.init(
            limjangId: limjangId,
            createdAt: createdAt
        )
    }
}
