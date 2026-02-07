//
//  Encodable+Extension.swift
//  juinjang
//
//  Created by KimDongWoo on 5/12/25.
//

import Foundation

extension Encodable {
    func toQueryItems(
        dateEncoding: ((Date) -> String)? = { ISO8601DateFormatter().string(from: $0) }
    ) -> [URLQueryItem] {
        
        Mirror(reflecting: self).children.compactMap { child in
            guard let key = child.label else { return nil }
            
            // Optional nil 처리
            let mirror = Mirror(reflecting: child.value)
            let value: Any?
            if mirror.displayStyle == .optional {
                value = mirror.children.first?.value   // 옵셔널 언래핑
            } else {
                value = child.value
            }
            guard let unwrapped = value else { return nil }  // nil이면 파라미터 제거
            
            switch unwrapped {
            case let str as String:
                return URLQueryItem(name: key, value: str)
                
            case let date as Date:
                return URLQueryItem(name: key, value: dateEncoding?(date))
                
            case let convertible as CustomStringConvertible:  // Int·Double·UUID·URL 등
                return URLQueryItem(name: key, value: convertible.description)
                
            default:
                // 배열·딕셔너리·중첩 객체 → JSON 문자열
                guard
                    JSONSerialization.isValidJSONObject(unwrapped),
                    let data = try? JSONSerialization.data(withJSONObject: unwrapped),
                    let json = String(data: data, encoding: .utf8)
                else { return nil }
                return URLQueryItem(name: key, value: json)
            }
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
    
    func toArray() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            print("❌ toArray Error: \(error)")
            return nil
        }
    }
}
