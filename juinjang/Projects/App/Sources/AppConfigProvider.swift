//
//  AppConfigProvider.swift
//  App
//
//  Created by KimDongWoo on 11/17/25.
//

import Foundation
import Core

public final class AppConfigProvider: AppConfigProviderProtocol {
    public static let shared = AppConfigProvider()
    
    private init() {}
    
    // MARK: - 인앱 결제 관련 Methods
    private func productsDictionary() -> [String: String] {
        guard let products = Bundle.main.object(forInfoDictionaryKey: "Products") as? [String: String] else {
            return [:]
        }
        return products
    }
    
    public func productIdentifiers() -> [String] {
        Array(productsDictionary().keys)
    }
    
    public func productPrice(for productId: String) -> Int {
        let dict = productsDictionary()
        return Int(dict[productId] ?? "") ?? 0
    }
    
    // MARK: - URL Methods
    public func getBaseURL(for type: BaseURLType) -> String {
        switch type {
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
