import Foundation
import CoreCommon
import DomainModel

public struct PencilShopAgreementResponse: Codable, DomainMappable {
    let status: Bool
    
    public func toDomain() -> PencilShopAgreement {
        return PencilShopAgreement.init(status: status)
    }
}
