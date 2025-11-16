import Foundation
import Core
import Domain

public struct PencilBalanceResponse: Codable, DomainMappable {
    let totalBalance: Int
    
    public func toDomain() -> PencilBalance {
        return PencilBalance.init(totalBalance: totalBalance)
    }
}
