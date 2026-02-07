//
//  BaseURLType.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import Foundation

enum BaseURLType {
    case juinjang
    case areaCode
    
    var url: String {
        switch self {
        case .juinjang:
            guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
                fatalError("❌ BASE_URL not found in Info.plist")
            }
            return baseURL
            
        case .areaCode:
            guard let areaCodeURL = Bundle.main.infoDictionary?["AREA_CODE_URL"] as? String else {
                fatalError("❌ AREA_CODE_URL not found in Info.plist")
            }
            return areaCodeURL
        }
    }
}
