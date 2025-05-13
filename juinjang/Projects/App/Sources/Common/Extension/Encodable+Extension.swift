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
}
