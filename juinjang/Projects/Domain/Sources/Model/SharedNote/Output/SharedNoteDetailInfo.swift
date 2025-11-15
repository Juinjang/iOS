//
//  ImjangDetailInfoModel.swift
//  juinjang
//
//  Created by KimDongWoo on 4/10/25.
//

public struct SharedNoteDetailInfo: Codable {
    var isBuyer: Bool
    let isImageShared: Bool
    let requiredPencils: Int?
    let imageCount: Int?
    let checkedCount: Int?
    let reviewLength: Int?
    let buildingName: String
    let limjangPurpose: String
    let propertyType: String
    let priceType: String
    let buyerCount: Int?
    let images: [String]
    let address: String
    let addressShort: String
    let price: String
    let monthlyRent: String?
    var isLiked: Bool
    var likedCount: Int?
    let period: String
    let updatedAt: String?
    let viewCount: Int
    let floor: String
    let pyong: Int
    let ownerProfileUrl: String?
    let ownerNickname: String
    let ownerProfileBio: String?
}
