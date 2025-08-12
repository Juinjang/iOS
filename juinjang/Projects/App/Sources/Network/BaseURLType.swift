//
//  BaseURLType.swift
//  juinjang
//
//  Created by KimDongWoo on 5/17/25.
//

import Foundation

enum BaseURLType {
    case juinjang
    case tempJuinjang
    case areaCode
    
    var url: String {
        switch self {
        case .juinjang:
            // MARK: - TEMP 추후 삭제 예정
            if UserDefaultManager.shared.isTesting ?? false {
                guard let baseURL = Bundle.main.infoDictionary?["REVIEW_URL"] as? String else {
                    fatalError("❌ REVIEW_URL not found in Info.plist")
                }
                
                return baseURL
            }
            
            guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
                fatalError("❌ BASE_URL not found in Info.plist")
            }
            return baseURL
            
        case .tempJuinjang:
            let isHttpsEnabled = UserDefaultManager.shared.isHttpsEnabled ?? false
            if !isHttpsEnabled {
                guard let baseURL = Bundle.main.infoDictionary?["HTTP_BASE_URL"] as? String else {
                    fatalError("❌ BASE_URL not found in Info.plist")
                }
                return baseURL
            }
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
