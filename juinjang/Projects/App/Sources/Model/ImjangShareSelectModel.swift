//
//  ImjangShareSelectModel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

struct ShareSelectModel: Codable {
    let noteId: Int
    let purposeType: String
    let propertyType: String
    let priceType: String
    let name: String
    let imageUrl: String
    let isScraped: Bool
    let rate: Double?
    let price: String
    let monthlyRent: String?
    let pyong: Int
    let floor: String
    let shortAddress: String
    let rewardPencil: Int
}
