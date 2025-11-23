//
//  AdmVOResponse.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import Foundation

public struct AdmVOResponse: Decodable, Hashable, DomainMappable {
    let admCode: String
    let lowestAdmCodeNm: String
    
    public func toDomain() -> AdmVO {
        return AdmVO.init(
            admCode: admCode,
            lowestAdmCodeNm: lowestAdmCodeNm
        )
    }
}
