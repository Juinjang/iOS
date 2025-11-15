import Foundation
import CoreCommon
import DomainModel

public struct TermsAgreementResponse: Codable, DomainMappable {
    let termsType: String
    let isAgreed: Bool
    
    public func toDomain() -> TermsAgreement {
        return TermsAgreement.init(
            termsType: termsType,
            isAgreed: isAgreed
        )
    }
}
