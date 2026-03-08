import ComposableArchitecture
import Common
import Foundation

// MARK: - Token Client Interface
/// 토큰 저장/조회를 담당하는 Interface
/// Live 구현은 Core/Network에서 제공

@DependencyClient
public struct TokenClient: Sendable {
    public var getAccessToken: @Sendable () -> String?
    public var getRefreshToken: @Sendable () -> String?
    public var saveAccessToken: @Sendable (_ token: String) -> Void
    public var saveRefreshToken: @Sendable (_ token: String) -> Void
    public var clearTokens: @Sendable () -> Void
}

// MARK: - TestDependencyKey

extension TokenClient: TestDependencyKey {
    public static let testValue = Self()
}

extension DependencyValues {
    public var tokenClient: TokenClient {
        get { self[TokenClient.self] }
        set { self[TokenClient.self] = newValue }
    }
}
