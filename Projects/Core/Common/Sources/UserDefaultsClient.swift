//
//  UserDefaultsClient.swift
//  Common
//
//  Created by 조유진 on 3/8/26.
//

import ComposableArchitecture
import Foundation

// MARK: - UserDefaults Client

@DependencyClient
public struct UserDefaultsClient: Sendable {

    // MARK: - 기본 타입 (String, Int, Bool, Double, Data)
    public var get: @Sendable (_ forKey: Key) throws -> Data
    public var set: @Sendable (_ data: Data, _ forKey: Key) -> Void
    public var remove: @Sendable (_ forKey: Key) -> Void
    public var hasValue: @Sendable (_ forKey: Key) -> Bool
}

// MARK: - 타입 안전한 편의 메서드
/// Feature에서 직접 사용하는 인터페이스

extension UserDefaultsClient {

    public func load<T: Codable & Sendable>(
        _ key: Key,
        type: T.Type = T.self
    ) throws -> T {
        let data = try get(key)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw UserDefaultsError.decodingFailed(key: key, underlying: error)
        }
    }

    public func save<T: Codable & Sendable>(
        _ value: T,
        forKey key: Key
    ) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        set(data, key)
    }

    public func string(_ key: Key) throws -> String {
        try load(key)
    }
    
    public func bool(_ key: Key, default defaultValue: Bool = false) -> Bool {
        (try? load(key)) ?? defaultValue
    }
    
    public func integer(_ key: Key) throws -> Int {
        try load(key)
    }
}

// MARK: - DependencyKey

extension UserDefaultsClient: DependencyKey {

    public static var liveValue: UserDefaultsClient {
        let defaults = UserDefaults.standard

        return Self(
            get: { key in
                guard let data = defaults.data(forKey: key.rawValue) else {
                    throw UserDefaultsError.keyNotFound(key: key)
                }
                return data
            },
            set: { data, key in
                defaults.set(data, forKey: key.rawValue)
            },
            remove: { key in
                defaults.removeObject(forKey: key.rawValue)
            },
            hasValue: { key in
                defaults.object(forKey: key.rawValue) != nil
            }
        )
    }

    public static var testValue: UserDefaultsClient {
        UserDefaultsClient()
    }
}

// MARK: - DependencyValues 등록

public extension DependencyValues {
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

// MARK: - Key 정의

extension UserDefaultsClient {
    public enum Key: String, Sendable {
        case nickname
        case accessToken
        case refreshToken
        // 새 키는 여기에 추가
    }
}

// MARK: - Error 정의

public enum UserDefaultsError: Error, Equatable, Sendable, LocalizedError {
    case keyNotFound(key: UserDefaultsClient.Key)
    case decodingFailed(key: UserDefaultsClient.Key, underlying: Error)

    public var errorDescription: String? {
        switch self {
        case .keyNotFound(let key):
            return "[\(key.rawValue)] 값이 존재하지 않습니다"
        case .decodingFailed(let key, _):
            return "[\(key.rawValue)] 디코딩에 실패했습니다"
        }
    }

    public static func == (lhs: UserDefaultsError, rhs: UserDefaultsError) -> Bool {
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
