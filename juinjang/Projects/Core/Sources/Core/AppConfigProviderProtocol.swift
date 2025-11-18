//
//  AppConfigProviderProtocol.swift
//  Core
//
//  Created by KimDongWoo on 11/17/25.
//

public protocol AppConfigProviderProtocol {
    func productIdentifiers() -> [String]
    func productPrice(for productId: String) -> Int
    func getBaseURL(for type: BaseURLType) -> String
}
