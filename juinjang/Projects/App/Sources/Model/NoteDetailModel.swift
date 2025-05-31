//
//  NoteDetailModel.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import UIKit

struct NoteDetailModel: Codable {
    let purposeType: String
    let propertyType: String
    let priceType: String
    let buildingName: String
    let images: [String]
    let address: String
    let price: String
    let monthlyRent: String?
    let updatedAt: String
    let floor: String?
    let pyong: Int?
    let isShared: Bool
}

extension NoteDetailModel {
    var priceTypeToString: String {
        switch self.priceType {
        case "SALE":
            return "매매"
        case "PULL_RENT":
            return "전세"
        case "MONTHLY_RENT":
            return "월세"
        case "MARKET_PRICE":
            return "실거래가"
        default:
            return ""
        }
    }
    
    var propertyTypeImage: UIImage {
        switch self.propertyType {
        case "APARTMENT":
            return UIImage.apartmentDetail
        case "VILLA":
            return UIImage.villaDetail
        case "OFFICE_TEL":
            return UIImage.officeTelDetail
        case "DETACHED_HOUSE":
            return UIImage.detachedHouseDetail
        default:
            return UIImage.apartmentDetail
        }
    }
    
    var propertyTypeToKorean: String {
        switch self.propertyType {
        case "APARTMENT":
            return "아파트"
        case "VILLA":
            return "빌라"
        case "OFFICE_TEL":
            return "오피스텔"
        case "DETACHED_HOUSE":
            return "주택"
        default:
            return ""
        }
    }
}
