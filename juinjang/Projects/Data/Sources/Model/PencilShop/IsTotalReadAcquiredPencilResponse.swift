import Foundation
import Core
import Domain

public struct IsTotalReadAcquiredPencilResponse: Codable {
    let isTotalRead: Bool
    
    public func toDomain() -> IsTotalReadAcquiredPencil {
        return IsTotalReadAcquiredPencil.init(
            isTotalRead: isTotalRead
        )
    }
}
