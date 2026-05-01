import Foundation

// MARK: - DSNavigationAction
/// `DSNavigationBar`에서 발생하는 액션.
/// 각 버튼 탭, 검색 활성화/제출 등을 호출부가 `onAction(_:)`으로 처리.

public enum DSNavigationAction: Equatable, Sendable {
    case popButtonTap
    case closeButtonTap
    case textButtonTap

    case searchButtonTap
    case searchSubmit(keyword: String)
    case searchActive(isActive: Bool)

    case settingButtonTap
    case recordButtonTap
    case addButtonTap
    case trashButtonTap
    case reportButtonTap
    case startRecordButtonTap
}
