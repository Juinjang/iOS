import Foundation

import ComposableArchitecture

// MARK: - AppVersionClient Preview Mock
/// SwiftUI Preview에서 자동 사용되는 mock.
/// 기본은 latest == current — 업데이트 알림이 뜨지 않는 정상 상태.
/// 업데이트 알림 UI를 Preview에서 보고 싶다면 호출 측에서 `latestVersion`만 override.

extension AppVersionClient {
    public static let previewValue = AppVersionClient(
        latestVersion: { "1.0.0" },
        currentVersion: { "1.0.0" }
    )
}
