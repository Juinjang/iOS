//
//  MyImjangResponseModel.swift
//  juinjang
//
//  Created by KimDongWoo on 6/2/25.
//

import UIKit

struct MyImjangResponseDTO: Codable {
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
    let address: String
    let shortAddress: String
}

extension MyImjangResponseDTO {
    var priceTypeString: String {
        switch priceType {
        case "SALE":
            return "매매"
        case "PULL_RENT":
            return "전세"
        case "MONTHLY_RENT":
            return "월세"
        case "MARKET_PRICE":
            return "실거래가"
        default:
            return "" // 값이 없을 경우 공백 처리
        }
    }
    
    var propertyTypeToHolderImage: UIImage {
        switch propertyType {
        case "APARTMENT":
            return .ImjangList.apartment
        case "VILLA":
            return .ImjangList.villa
        case "OFFICE_TEL":
            return .ImjangList.officeTel
        case "DETACHED_HOUSE":
            return .ImjangList.detachedHouse
        default:
            return .ImjangList.detachedHouse
        }
    }
}
