//
//  ExploreNoteModel.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

struct ExploreNoteModel: Codable, Hashable {
    let sharedNoteId: Int
    let propertyType: String
    let priceType: String
    let buildingName: String
    let imageUrl: String?
    let isPurchase: Bool
    let isLiked: Bool
    let rate: String?
    let price: String
    let monthlyRent: String?
    let pyong: Int?
    let floor: String?
    let address: String
    let ownerImageUrl: String?
    let ownerNickname: String
    let timeAgo: String?
    let viewCount: Int
}

