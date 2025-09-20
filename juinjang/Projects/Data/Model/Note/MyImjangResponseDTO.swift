//
//  MyImjangResponseModel.swift
//  juinjang
//
//  Created by KimDongWoo on 6/2/25.
//

import Foundation

public struct MyImjangResponseDTO: Codable {
    let noteId: Int
    let purposeType: String
    let propertyType: String
    let priceType: String
    let name: String
    let imageUrl: [String]
    var isScraped: Bool
    let rate: String?
    let price: String
    let monthlyRent: String?
    let pyong: Int?
    let floor: String?
    let address: String?
    let shortAddress: String?
}
