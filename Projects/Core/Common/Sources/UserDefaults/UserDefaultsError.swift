//
//  UserDefaultsError.swift
//  Common
//
//  Created by 조유진 on 4/18/26.
//

import Foundation

public enum UserDefaultsError: Error, Equatable, Sendable, LocalizedError {
    case keyNotFound(key: UserDefaultsKey)
    case decodingFailed(key: UserDefaultsKey, underlying: Error)

    public var errorDescription: String? {
        switch self {
        case .keyNotFound(let key):
            return "[\(key.rawValue)] 값이 존재하지 않습니다"
        case .decodingFailed(let key, _):
            return "[\(key.rawValue)] 디코딩에 실패했습니다"
        }
    }

    public static func == (
        lhs: UserDefaultsError,
        rhs: UserDefaultsError
    ) -> Bool {
        switch (lhs, rhs) {
        case (.keyNotFound(let leftKey), .keyNotFound(let rightKey)):
            return leftKey == rightKey
        case (.decodingFailed(let leftKey, let leftError), .decodingFailed(let rightKey, let rightError)):
            return leftKey == rightKey
                && leftError.localizedDescription == rightError.localizedDescription
        default:
            return false
        }
    }
}
