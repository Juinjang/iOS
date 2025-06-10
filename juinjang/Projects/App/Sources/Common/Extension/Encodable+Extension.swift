//
//  Encodable+Extension.swift
//  juinjang
//
//  Created by KimDongWoo on 5/12/25.
//

import Foundation

extension Encodable {
    func toQueryItems() -> [URLQueryItem] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.compactMap { child in
            guard let key = child.label else { return nil }
            return URLQueryItem(name: key, value: "\(child.value)")
        }
    }
    
    func toDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return dict
        } catch {
            print("❌ toDictionary Error: \(error)")
            return nil
        }
    }
}
