//
//  RecentUpdatedDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct TotalListDto: Codable {
    var limjangList: [ListDto]
}

struct RecentUpdatedDto: Codable {
    let recentUpdatedList: [LimjangDto]
}

struct MainImjangDto: Codable {
    let limjangId: Int
    let image: String?
    let nickname: String
    let price: String
    let totalAverage: String?
    let address: String
}

struct ListDto: Codable, Hashable {
    var id: UUID
    let limjangId: Int
    let images: [String]
    let purposeCode: Int        // 거래목적
    var isScraped: Bool
    let nickname: String
    let priceType: Int
    let priceList: [String]
    let totalAverage: String?    // 체크리스트 생선 전일 경우 값은 nil
    let address: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.limjangId = try container.decode(Int.self, forKey: .limjangId)
        self.images = try container.decode([String].self, forKey: .images)
        self.purposeCode = try container.decode(Int.self, forKey: .purposeCode)
        self.isScraped = try container.decode(Bool.self, forKey: .isScraped)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.priceType = try container.decode(Int.self, forKey: .priceType)
        self.priceList = try container.decode([String].self, forKey: .priceList)
        self.totalAverage = try container.decodeIfPresent(String.self, forKey: .totalAverage)
        self.address = try container.decode(String.self, forKey: .address)
    }
    
    init(
        id: UUID = UUID(),
        limjangId: Int = 123,
        images: [String] = ["image1.jpg", "image2.jpg"],
        purposeCode: Int = 1,
        isScraped: Bool = false,
        nickname: String = "채드",
        priceType: Int = 2,
        priceList: [String] = ["1000", "2000"],
        totalAverage: String? = "1500",
        address: String = "서울시 강남구"
    ) {
        self.id = id
        self.limjangId = limjangId
        self.images = images
        self.purposeCode = purposeCode
        self.isScraped = isScraped
        self.nickname = nickname
        self.priceType = priceType
        self.priceList = priceList
        self.totalAverage = totalAverage
        self.address = address
    }
}

struct LimjangDto: Codable {
    let limjangId: Int
    let priceType: Int
    let image: String?
    let nickname: String
    let price: String
    let totalAverage: String?    // 체크리스트 생선 전일 경우 값은 nil
    let address: String
}

struct LimjangDTO: Codable {
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
