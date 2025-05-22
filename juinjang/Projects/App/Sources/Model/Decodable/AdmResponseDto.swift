//
//  AdmResponseDto.swift
//  juinjang
//
//  Created by 조유진 on 5/6/25.
//


struct AdmResponseDto: Decodable {
    let admVOList: AdmVOInfo
}

struct AdmVOInfo: Decodable {
    let pageNo: String?
    let totalCount: String
    let error: String
    let message: String
    let numOfRows: String
    var admVOList: [AdmVO]
}

struct AdmVO: Decodable, Hashable {
    let admCode: String
    let lowestAdmCodeNm: String
}


