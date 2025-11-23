//
//  AdmVO.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import Foundation

public struct AdmVO {
    let admCode: String
    let lowestAdmCodeNm: String
    
    public init(admCode: String, lowestAdmCodeNm: String) {
        self.admCode = admCode
        self.lowestAdmCodeNm = lowestAdmCodeNm
    }
}
