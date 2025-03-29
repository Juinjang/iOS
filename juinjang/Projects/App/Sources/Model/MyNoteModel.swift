//
//  MyNoteModel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/15/25.
//

struct MyNoteModel: Codable {
    let sharedNoteId: Int
    let bulidingName: String
    let imageUrl: String
    let isPurchase: Bool
    var isLike: Bool
    let rate: Double
    let type: String
    let price: String
    let pyong: Int
    let floor: String
    let address: String
    let onwerImageUrl: String
    let onwerNickname: String
    let monthAge: Int
    let viewCount: Int
}
