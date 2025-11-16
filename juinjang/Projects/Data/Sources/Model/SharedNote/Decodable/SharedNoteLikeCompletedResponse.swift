import Foundation
import Core
import Domain

public struct SharedNoteLikeCompletedResponse: Codable, DomainMappable {
    let count: Int
    
    public func toDomain() -> SharedNoteLikeCompleted {
        return SharedNoteLikeCompleted.init(count: count)
    }
}
