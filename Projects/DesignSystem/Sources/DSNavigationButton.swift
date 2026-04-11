import SwiftUI

// MARK: - DSNavigationButton
/// 네비게이션 바 버튼 타입 정의

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

// MARK: - DSNavigationAction
/// 네비게이션 바에서 발생하는 액션

public enum DSNavigationAction: Equatable {
    case popButtonTap
    case searchButtonTap
    case searchSubmit(keyword: String)
    case searchActive(isActive: Bool)
    case settingButtonTap
    case recordButtonTap
    case addButtonTap
    case closeButtonTap
    case textButtonTap
    case trashButtonTap
    case reportButtonTap
    case startRecordButtonTap
}
