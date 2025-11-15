//
//  Decodable+Extension.swift
//  juinjang
//
//  Created by KimDongWoo on 5/26/25.
//

import Foundation

extension Decodable {
    static func from(dictionary: [String: Any]) -> Self? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print("❌ Decoding failed: \(error)")
            return nil
        }
    }
}
