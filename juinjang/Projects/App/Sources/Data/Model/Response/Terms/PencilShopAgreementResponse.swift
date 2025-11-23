//
//  PencilShopAgreementResponse.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import Foundation

public struct PencilShopAgreementResponse: Codable, DomainMappable {
    let status: Bool
    
    public func toDomain() -> PencilShopAgreement {
        return PencilShopAgreement.init(status: status)
    }
}
