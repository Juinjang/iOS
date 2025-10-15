import Foundation
import CoreCommon
import DomainModel

public struct SharedNoteLikeCompletedResponse: Codable, DomainMappable {
    let count: Int
    
    public func toDomain() -> SharedNoteLikeCompleted {
        return SharedNoteLikeCompleted.init(count: count)
    }
}
