import Foundation

// MARK: - ThrottleID
/// `apiThrottle(id:)`에 넘기는 effect 격리용 식별자.
/// effect별로 별도 case를 둬서 서로 다른 API가 throttle을 공유하지 않도록 한다.
///
/// - 외부 노출 없이 모듈 내 `internal` 접근으로 충분.
///   (extension 분할 위해 `private`이 아니라 default access 사용)

extension SettingFeature {
    enum ThrottleID: Hashable {
        case profileLoad
        case nicknameSave
        case introSave
        case profileImageUpload
        case logout
    }
}
