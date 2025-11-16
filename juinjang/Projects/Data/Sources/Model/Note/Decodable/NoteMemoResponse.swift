import Foundation
import Core
import Domain

public struct NoteMemoResponse: Codable, DomainMappable {
    let limjangId: Int
    let createdAt: String
    let updatedAt: String
    let memo: String?
    
    public func toDomain() -> NoteMemo {
        return NoteMemo.init(
            limjangId: limjangId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            memo: memo
        )
    }
}
