//
//  AppConfigProviderProtocol.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

public protocol AppConfigProviderProtocol {
    func productIdentifiers() -> [String]
    func productPrice(for productId: String) -> Int
    func getBaseURL(for type: BaseURLType) -> String
}
