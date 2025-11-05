//
//  PriceType.swift
//  juinjang
//
//  Created by KimDongWoo on 4/11/25.
//

enum PriceType: String {
    case SALE
    case PULL_RENT
    case MONTHLY_RENT
    case MARKET_PRICE
    
    var title: String {
        switch self {
        case .SALE:
            return "매매"
        case .PULL_RENT:
            return "전세"
        case .MONTHLY_RENT:
            return "월세"
        case .MARKET_PRICE:
            return "시세"
        }
    }
    
    var number: Int {
        switch self {
        case .SALE: 0
        case .PULL_RENT: 1
        case .MONTHLY_RENT: 2
        case .MARKET_PRICE: 3
        }
    }
}
