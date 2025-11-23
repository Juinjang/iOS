//
//  TermsAgreement.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import Foundation

public struct TermsAgreement {
    let termsType: String
    let isAgreed: Bool
    
    public init(termsType: String, isAgreed: Bool) {
        self.termsType = termsType
        self.isAgreed = isAgreed
    }
}
