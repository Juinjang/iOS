//
//  MyNoteModel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/15/25.
//

struct MyNoteModel: Codable {
    let sharedNoteId: Int
    let buildingName: String
    let imageUrl: String?
    let isPurchase: Bool
    var isLiked: Bool
    let rate: String
    let price: String
    let monthlyRent: String?
    let pyong: Int?
    let floor: String?
    let address: String
    let ownerImageUrl: String?
    let ownerNickname: String
    let timeAge: String
    let viewCount: Int
    let propertyType: String
    let priceType: String
}
