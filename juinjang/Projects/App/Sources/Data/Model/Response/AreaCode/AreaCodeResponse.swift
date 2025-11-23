//
//  AreaCodeResponse.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import Foundation

public struct AreaCodeResponse: Decodable, DomainMappable {
    let admVOList: AdmVOInfoResponse
    
    public func toDomain() -> AreaCode {
        return AreaCode.init(admVOList: admVOList.toDomain() )
    }
}
