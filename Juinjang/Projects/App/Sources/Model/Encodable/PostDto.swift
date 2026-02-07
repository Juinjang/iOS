//
//  PostDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct PostDto: Encodable {
    let purposeType: Int  // 거래목적(0 - 부동산 투자, 1 - 직접 입주)
    let propertyType: Int // 매물유형(0 - 아파트, 1 - 빌라, 2 - 오피스텔, 3 - 단독주택)
    let priceType: Int    // 가격유형(0 - 매매, 1 - 전세, 2 - 월세, 3 - 실거래가
    let price: String   // 가격 - 월세의 경우에만 보증금
    let monthlyRent: String?
    let address: String   // 주소
    let roadAddress: String
    let addressDetail: String   // 상세주소
    let nickname: String    // 집별명
}

extension PostDto {
    var purposeTypeToString: String {
        switch self.purposeType {
        case 0:
            return "INVESTMENT"
        case 1:
            return "RESIDENTIAL_PURPOSE"
        default:
            return ""
        }
    }
    
    var propertyTypeToString: String {
        switch self.propertyType {
        case 0:
            return "APARTMENT"
        case 1:
            return "VILLA"
        case 2:
            return "OFFICE_TEL"
        case 3:
            return "DETACHED_HOUSE"
        default:
            return ""
        }
    }
    
    var priceTypeToString: String {
        switch self.priceType {
        case 0:
            return "SALE"
        case 1:
            return "PULL_RENT"
        case 2:
            return "MONTHLY_RENT"
        case 3:
            return "MARKET_PRICE"
        default:
            return ""
        }
    }
}
