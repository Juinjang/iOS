import Foundation
import CoreCommon
import DomainModel

public struct PencilBalanceResponse: Codable, DomainMappable {
    let totalBalance: Int
    
    public func toDomain() -> PencilBalance {
        return PencilBalance.init(totalBalance: totalBalance)
    }
}
