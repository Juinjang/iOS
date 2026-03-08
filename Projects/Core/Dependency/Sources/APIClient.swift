import ComposableArchitecture
import Model

// MARK: - API Client Interface
/// Feature 모듈은 이 Interface만 의존합니다.
/// 실제 구현(Live)은 Core/Network에 위치합니다.

@DependencyClient
public struct APIClient: Sendable {
    public var fetchHomeFeed: @Sendable () async throws -> [Post]
    public var fetchUserProfile: @Sendable (_ userId: String) async throws -> User
}

// MARK: - TestDependencyKey

extension APIClient: TestDependencyKey {
    public static let testValue = Self()
}

// MARK: - DependencyValues 등록

extension DependencyValues {
    public var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
