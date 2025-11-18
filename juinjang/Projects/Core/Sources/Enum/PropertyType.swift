//
//  PropertyType.swift
//  juinjang
//
//  Created by KimDongWoo on 4/11/25.
//

import UIKit

public enum PropertyType: String, CaseIterable {
    case APARTMENT
    case VILLA
    case OFFICE_TEL
    case DETACHED_HOUSE

    var image: UIImage {
        switch self {
        case .APARTMENT: return .ImjangList.apartment
        case .VILLA: return .ImjangList.villa
        case .OFFICE_TEL: return .ImjangList.officeTel
        case .DETACHED_HOUSE: return .ImjangList.detachedHouse
        }
    }
    
    var detailImage: UIImage {
        switch self {
        case .APARTMENT: return .apartmentDetail
        case .VILLA: return .villaDetail
        case .OFFICE_TEL: return .officeTelDetail
        case .DETACHED_HOUSE: return .detachedHouseDetail
        }
    }
    
    var title: String {
        switch self {
        case .APARTMENT: return "아파트"
        case .VILLA: return "빌라"
        case .OFFICE_TEL: return "오피스텔"
        case .DETACHED_HOUSE: return "주택"
        }
    }
}
