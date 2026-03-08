import Foundation

// MARK: - 키-값 저장소 프로토콜

public protocol KeyValueStorage: Sendable {
    func get<T>(_ type: T.Type, for key: StorageKey) -> T?
    func set<T>(_ value: T?, for key: StorageKey)
    func remove(for key: StorageKey)
}

public enum StorageKey: String, Sendable {
    case accessToken
    case refreshToken
    case userId
}

public final class UserDefaultsStorage: KeyValueStorage, @unchecked Sendable {
    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func get<T>(_ type: T.Type, for key: StorageKey) -> T? {
        defaults.object(forKey: key.rawValue) as? T
    }

    public func set<T>(_ value: T?, for key: StorageKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    public func remove(for key: StorageKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
