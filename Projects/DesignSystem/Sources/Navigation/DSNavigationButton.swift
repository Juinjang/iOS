import SwiftUI

// MARK: - DSNavigationButton
/// 네비게이션 바 좌/우 영역에 들어가는 버튼 종류.
/// 이미지·크기·틴트는 enum이 책임지고, 액션 매핑은 `DSNavigationAction`을 통해 표현.

public enum DSNavigationButton: Equatable {
    case pop
    case search
    case setting
    case record
    case add
    case close
    case trash
    case report
    case startRecord
    case text(title: String)

    var image: Image? {
        switch self {
        case .pop: return .arrowLeft
        case .search: return .search
        case .setting: return .setting
        case .record: return .record
        case .add: return .add
        case .close: return .close
        case .trash: return .trash
        case .report: return .siren
        case .startRecord: return .addOrange
        case .text: return nil
        }
    }

    var buttonSize: CGFloat {
        switch self {
        case .report: return 18
        case .startRecord: return 22
        default: return 24
        }
    }

    var tintColor: Color {
        switch self {
        case .startRecord: return .main
        default: return .gray450
        }
    }
}
