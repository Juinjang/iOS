//
//  UserDefaultsClient.swift
//  Dependency
//
//  Created by 조유진 on 3/9/26.
//

import Foundation

import Common

import ComposableArchitecture

// MARK: - UserDefaults Client
/// TCA @DependencyClient 기반 UserDefaults 래퍼입니다.
/// 모든 값을 Data(Codable)로 저장하여 타입 안전성을 보장합니다.

@DependencyClient
public struct UserDefaultsClient: Sendable {

    /// Data 조회 (throws → 기본값 불필요)
    public var get: @Sendable (_ forKey: UserDefaultsKey) throws -> Data

    /// Data 저장
    public var set: @Sendable (_ data: Data, _ forKey: UserDefaultsKey) -> Void = { _, _ in }

    /// 키 삭제
    public var remove: @Sendable (_ forKey: UserDefaultsKey) -> Void = { _ in }

    /// 키 존재 여부 확인
    public var hasValue: @Sendable (_ forKey: UserDefaultsKey) -> Bool = { _ in false }
}

// MARK: - 타입 안전한 편의 메서드
///
/// 사용법:
///   let nickname: String = try userDefaultsClient.load(.nickname)
///   userDefaultsClient.save("유진", forKey: .nickname)
///   userDefaultsClient.save(true, forKey: .isFirstVoteDone)
///   let isDone = userDefaultsClient.bool(.isFirstVoteDone, default: false)

extension UserDefaultsClient {

    /// Codable 값 조회
    public func load<T: Codable & Sendable>(
        _ key: UserDefaultsKey,
        type: T.Type = T.self
    ) throws -> T {
        let data = try get(key)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw UserDefaultsError.decodingFailed(key: key, underlying: error)
        }
    }

    /// Codable 값 저장
    public func save<T: Codable & Sendable>(
        _ value: T,
        forKey key: UserDefaultsKey
    ) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        set(data, key)
    }

    public func string(_ key: UserDefaultsKey) throws -> String {
        try load(key)
    }

    public func bool(_ key: UserDefaultsKey, default defaultValue: Bool = false) -> Bool {
        (try? load(key)) ?? defaultValue
    }
    
    public func integer(_ key: UserDefaultsKey) throws -> Int {
        try load(key)
    }

    public func double(_ key: UserDefaultsKey) throws -> Double {
        try load(key)
    }
}

// MARK: - DependencyKey (Live 구현)

extension UserDefaultsClient: DependencyKey {

    public static var liveValue: UserDefaultsClient {
        nonisolated(unsafe) let defaults = UserDefaults.standard

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
        nonisolated(unsafe) var storage: [String: Data] = [:]
        return Self(
            get: { key in
                guard let data = storage[key.rawValue] else {
                    throw UserDefaultsError.keyNotFound(key: key)
                }
                return data
            },
            set: { data, key in storage[key.rawValue] = data },
            remove: { key in storage.removeValue(forKey: key.rawValue) },
            hasValue: { key in storage[key.rawValue] != nil }
        )
    }
}

// MARK: - DependencyValues 등록

public extension DependencyValues {
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}
