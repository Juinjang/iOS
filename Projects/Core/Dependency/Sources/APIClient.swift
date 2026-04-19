import Common
import Model

import ComposableArchitecture

// MARK: - API Client Interface
/// Feature 모듈이 의존하는 네트워크 Interface
/// 실제 구현(Live)은 Core/Network에서 Alamofire로 수행
///
///   public var fetchSomeData: @Sendable () async throws -> SomeModel

@DependencyClient
public struct APIClient: Sendable {

    // MARK: - User
    public var fetchUserProfile: @Sendable (_ userId: String) async throws -> User
}

// MARK: - TestDependencyKey

extension APIClient: TestDependencyKey {
    public static let testValue = APIClient()
}

extension DependencyValues {
    public var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
