import Foundation
import CoreCommon
import DomainModel

public struct IsTotalReadAcquiredPencilResponse: Codable {
    let isTotalRead: Bool
    
    public func toDomain() -> IsTotalReadAcquiredPencil {
        return IsTotalReadAcquiredPencil.init(
            isTotalRead: isTotalRead
        )
    }
}
