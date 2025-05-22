//
//  NoteDetailModel.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

struct NoteDetailModel: Codable {
    let purposeType: String
    let propertyType: String
    let priceType: String
    let buildingName: String
    let images: [String]
    let address: String
    let price: String
    let monthlyRent: String
    let updatedAt: String
    let floor: String
    let pyong: Int
}
