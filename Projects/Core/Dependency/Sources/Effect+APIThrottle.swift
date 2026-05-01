import ComposableArchitecture
import Dispatch
import Foundation

// MARK: - Effect.apiThrottle
/// API 호출 effect의 중복 발화를 막는 헬퍼.
///
/// 첫 발화는 즉시 실행, throttle 윈도우 안에 들어온 후속 발화는 모두 무시.
/// (RxSwift `throttle(_:latest: false)`와 동일한 의미)
///
/// 사용 예:
/// ```
/// private enum ThrottleID: Hashable {
///     case nicknameSave, introSave, profileUpload, logout
/// }
///
/// case .view(.nicknameFieldButtonTapped):
///     return .run { send in
///         await send(.nicknameSaveResponse(...))
///     }
///     .apiThrottle(id: ThrottleID.nicknameSave)
/// ```
///
/// **언제 쓰나**
/// - API/네트워크/외부 시스템을 호출하는 모든 effect
/// - 로그아웃·계정 삭제·결제 등 confirm 후 실행되는 effect
///
/// **언제 안 쓰나**
/// - 단순 navigation push, 상태 토글 등 부수효과 없는 동작
///
/// **ID 운용**
/// - effect별로 고유 ID를 줘야 서로 다른 API가 throttle을 공유하지 않음
/// - feature 내부에서 `private enum ThrottleID: Hashable {}` 정의해서 사용 권장

// Swift 6 strict concurrency: 아래 두 타입은 모두 enum/struct 값이라 본질적으로 Sendable이지만
// Foundation/Dispatch가 명시 conformance를 안 박아서 컴파일러가 거부.
// retroactive 채택으로 Effect.throttle scheduler 매개변수의 Sendable 요구 충족.
extension DispatchTimeInterval: @unchecked @retroactive Sendable {}
extension DispatchQueue.SchedulerTimeType.Stride: @unchecked @retroactive Sendable {}

public extension Effect where Action: Sendable {
    /// API 호출 effect의 throttle. 기본 1.5초.
    /// - Parameters:
    ///   - id: effect 격리용 식별자. feature별 enum 정의 권장.
    ///   - seconds: throttle 윈도우 (기본 1.5초 — RxSwift 시절 `throttleTap` 기본값).
    func apiThrottle<ID: Hashable & Sendable>(
        id: ID,
        seconds: Double = 1.5
    ) -> Self {
        @Dependency(\.mainQueue) var mainQueue
        return self.throttle(
            id: id,
            for: .seconds(seconds),
            scheduler: mainQueue,
            latest: false
        )
    }
}
