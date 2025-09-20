//
//  Limjang.swift
//  Domain
//
//  Created by KimDongWoo on 9/20/25.
//

public struct LimjangDto: Codable {
    let limjangId: Int
    let priceType: Int
    let image: String?
    let nickname: String
    let price: String
    let totalAverage: String?    // 체크리스트 생선 전일 경우 값은 nil
    let address: String?
}

public struct LimjangDTO: Codable {
    let limjangId: Int
    let images: [String]
    let purposeCode: Int
    let nickname: String
    let priceType: Int
    let priceList: [String]
    let address: String
    let addressDetail: String
    let createdAt: String
    let updatedAt: String
}
