//
//  UserDefaultsClient.swift
//  Dependency
//
//  Created by 조유진 on 3/9/26.
//

import ComposableArchitecture
import Foundation

// MARK: - UserDefaults Client
/// TCA @DependencyClient 기반 UserDefaults 래퍼입니다.
/// 모든 값을 Data(Codable)로 저장하여 타입 안전성을 보장합니다.

@DependencyClient
public struct UserDefaultsClient: Sendable {

    /// Data 조회 (throws → 기본값 불필요)
    public var get: @Sendable (_ forKey: Key) throws -> Data

    /// Data 저장
    public var set: @Sendable (_ data: Data, _ forKey: Key) -> Void = { _, _ in }

    /// 키 삭제
    public var remove: @Sendable (_ forKey: Key) -> Void = { _ in }

    /// 키 존재 여부 확인
    public var hasValue: @Sendable (_ forKey: Key) -> Bool = { _ in false }
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

    /// Codable 값 저장
    public func save<T: Codable & Sendable>(
        _ value: T,
        forKey key: Key
    ) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        set(data, key)
    }

    /// String 편의 조회
    public func string(_ key: Key) throws -> String {
        try load(key)
    }

    /// Bool 편의 조회 (기본값 지원)
    public func bool(_ key: Key, default defaultValue: Bool = false) -> Bool {
        (try? load(key)) ?? defaultValue
    }

    /// Int 편의 조회
    public func integer(_ key: Key) throws -> Int {
        try load(key)
    }

    /// Double 편의 조회
    public func double(_ key: Key) throws -> Double {
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
        case userId
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
