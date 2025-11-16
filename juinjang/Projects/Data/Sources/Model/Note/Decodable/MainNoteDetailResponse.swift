//
//  MainNoteDetailResponse.swift
//  Data
//
//  Created by KimDongWoo on 11/11/25.
//

import Core
import Domain

public struct MainNoteDetailResponse: Codable, DomainMappable {
    public let limjangId: Int
    public let checkListVersion: String // 버전 (임장용 체크리스트 - LIMJANG,  원룸용 체크리스트 - NON_LIMJANG)
    public let images: [String]
    public let purposeCode: Int    // 거래목적 (0 - 부동산 투자, 1 - 직접 거주)
    public let nickname: String
    public let priceType: Int
    public let priceList: [String] // 월세일 경우 보증금, 월세 순
    public let address: String?
    public let addressDetail: String?
    public let createdAt: String
    public let updatedAt: String
    
    public func toDomain() -> MainNoteDetail {
        return MainNoteDetail(
            limjangId: limjangId,
            checkListVersion: checkListVersion,
            images: images,
            purposeCode: purposeCode,
            nickname: nickname,
            priceType: priceType,
            priceList: priceList,
            address: address,
            addressDetail: addressDetail,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
