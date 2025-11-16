import Foundation
import Core
import Domain

public struct PencilShopAgreementResponse: Codable, DomainMappable {
    let status: Bool
    
    public func toDomain() -> PencilShopAgreement {
        return PencilShopAgreement.init(status: status)
    }
}
