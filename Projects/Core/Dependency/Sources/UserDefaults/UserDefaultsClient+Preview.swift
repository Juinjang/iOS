import ComposableArchitecture

// MARK: - UserDefaultsClient Preview Mock
/// SwiftUI Preview에서 자동 사용되는 mock.
/// 메모리 기반 in-memory storage — testValue와 동일 동작 (저장/조회만 가능, 앱 재실행 시 초기화).

extension UserDefaultsClient {
    public static let previewValue: UserDefaultsClient = .testValue
}
