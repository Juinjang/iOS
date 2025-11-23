//
//  AdmVOInfoResponse.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import Foundation

public struct AdmVOInfoResponse: Decodable, DomainMappable {
    let pageNo: String?
    let totalCount: String
    let error: String
    let message: String
    let numOfRows: String
    var admVOList: [AdmVOResponse]
    
    public func toDomain() -> AdmVOInfo {
        return AdmVOInfo.init(
            pageNo: pageNo,
            totalCount: totalCount,
            error: error,
            message: message,
            numOfRows: numOfRows,
            admVOList: admVOList.map { $0.toDomain() }
        )
    }
}
