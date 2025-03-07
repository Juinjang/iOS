//
//  DetailDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation
 
struct DetailDto: Codable {
    let limjangId: Int
    let checkListVersion: String // 버전 (임장용 체크리스트 - LIMJANG,  원룸용 체크리스트 - NON_LIMJANG)
    let images: [String]
    let purposeCode: Int    // 거래목적 (0 - 부동산 투자, 1 - 직접 거주)
    let nickname: String
    let priceType: Int
    let priceList: [String] // 월세일 경우 보증금, 월세 순
    let address: String
    let addressDetail: String?
    let createdAt: String
    let updatedAt: String
}

struct RecordMemoDto: Codable {
    let limjangId: Int
    let memo: String?
    let createdAt: String
    let updatedAt: String
    let recordDto: [RecordResponse]
}

struct MemoDto: Codable {
    let limjangId: Int
    let createdAt: String
    let updatedAt: String
    let memo: String?
}
