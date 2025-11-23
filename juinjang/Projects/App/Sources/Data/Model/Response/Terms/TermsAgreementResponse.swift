//
//  TermsAgreementResponse.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import Foundation

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
