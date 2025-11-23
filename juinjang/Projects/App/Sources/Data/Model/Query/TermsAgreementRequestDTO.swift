//
//  TermsAgreementRequestDTO.swift
//  juinjang
//
//  Created by KimDongWoo on 7/26/25.
//

struct TermsAgreementRequestDTO: Codable {
    let termsType: String // 연필 상점 : "PENCIL_SHOP_SERVICE"
    let isAgreed: Bool
}
