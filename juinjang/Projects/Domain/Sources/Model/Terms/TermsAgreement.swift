import Foundation

public struct TermsAgreement {
    let termsType: String
    let isAgreed: Bool
    
    public init(termsType: String, isAgreed: Bool) {
        self.termsType = termsType
        self.isAgreed = isAgreed
    }
}
