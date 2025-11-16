import Foundation
import Core
import Domain

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
