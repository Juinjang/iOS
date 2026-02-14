//
//  URLConfiguration.swift
//  Data
//
//  Created by 조유진 on 2/14/26.
//

import Foundation

struct URLConfiguration {
    static var baseURL: String {
        guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("❌ BASE_URL not found in Info.plist")
        }
        return baseURL
    }
    
    static var areaURL: String {
        guard let areaCodeURL = Bundle.main.infoDictionary?["AREA_CODE_URL"] as? String else {
            fatalError("❌ AREA_CODE_URL not found in Info.plist")
        }
        return areaCodeURL
    }
}
