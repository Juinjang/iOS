import Foundation

// MARK: - DSNavigationBarStyle
/// 네비게이션 바 표시 모드.
/// - default: 가운데 타이틀 + 좌우 버튼
/// - search: 검색바 + 좌측 버튼
/// - center: 가운데에 커스텀 뷰 + 좌우 버튼

public enum DSNavigationBarStyle: Sendable {
    case `default`
    case search
    case center
}
