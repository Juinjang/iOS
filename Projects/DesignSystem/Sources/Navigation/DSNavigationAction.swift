import Foundation

// MARK: - DSNavigationAction
/// `DSNavigationBar`에서 발생하는 액션.
/// 각 버튼 탭, 검색 활성화/제출 등을 호출부가 `onAction(_:)`으로 처리.

public enum DSNavigationAction: Equatable, Sendable {
    case popButtonTapped
    case closeButtonTapped
    case textButtonTapped

    case searchButtonTapped
    case searchSubmitted(keyword: String)
    case searchActiveChanged(isActive: Bool)

    case settingButtonTapped
    case recordButtonTapped
    case addButtonTapped
    case trashButtonTapped
    case reportButtonTapped
    case startRecordButtonTapped
}
