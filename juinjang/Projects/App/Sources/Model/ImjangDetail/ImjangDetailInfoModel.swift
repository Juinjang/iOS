//
//  ImjangDetailInfoModel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/10/25.
//

struct ImjangDetailInfoModel: Codable {
    let isBuyer: Bool
    let requiredPencils: Int
    let imageCount: Int
    let checkedCount: Int
    let reviewLength: Int
    let bulidingName: String
    let propertyType: String
    let buyerCount: Int
    let images: [String]
    let address: String
    let addressShort: String
    let priceType: String
    let price: String
    let isLiked: Bool
    let likedCount: Int
    let period: String
    let updatedAt: String?
    let viewCount: Int
    let floor: String
    let pyung: String
    let owerProfileUrl: String
    let owerNickname: String
    let ownerProfileBio: String
}
