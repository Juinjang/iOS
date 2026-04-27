import Foundation

import Common
import Model

import ComposableArchitecture

// MARK: - UserClient Interface
/// 유저 도메인 (프로필 조회/수정, 인증 해제 등)에 대한 의존성 인터페이스.
/// Live 구현은 Networking 모듈에서, Preview mock은 +Preview 파일에서 정의합니다.

@DependencyClient
public struct UserClient: Sendable {

    // MARK: - Profile
    public var fetchMyProfile: @Sendable () async throws -> UserProfile
    public var updateNickname: @Sendable (_ nickname: String) async throws -> Void
    public var updateIntroduction: @Sendable (_ introduction: String) async throws -> Void
    public var uploadProfileImage: @Sendable (_ jpegData: Data) async throws -> String

    // MARK: - Auth
    public var logout: @Sendable () async throws -> Void
}

// MARK: - TestDependencyKey

extension UserClient: TestDependencyKey {
    public static let testValue = Self()
}

extension DependencyValues {
    public var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
