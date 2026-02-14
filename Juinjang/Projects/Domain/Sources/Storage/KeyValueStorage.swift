//
//  KeyValueStorage.swift
//  Domain
//
//  Created by 조유진 on 2/14/26.
//

import Foundation

public protocol KeyValueStorage {
    func set<T>(_ value: T, for key: UserDefaultsKey)
    func get<T>(_ type: T.Type, for key: UserDefaultsKey) -> T?
    func remove(for key: UserDefaultsKey)
}
