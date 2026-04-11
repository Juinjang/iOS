import ComposableArchitecture
import Foundation

// MARK: - App Version Client Interface
/// 앱 버전 조회를 위한 Interface
/// 실제 구현(Live)은 Core/Networking에서 iTunes API로 수행

@DependencyClient
public struct AppVersionClient: Sendable {
    public var latestVersion: @Sendable () async throws -> String
    public var currentVersion: @Sendable () -> String = { "0" }
}

// MARK: - TestDependencyKey

extension AppVersionClient: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues 등록

extension DependencyValues {
    public var appVersionClient: AppVersionClient {
        get { self[AppVersionClient.self] }
        set { self[AppVersionClient.self] = newValue }
    }
}
