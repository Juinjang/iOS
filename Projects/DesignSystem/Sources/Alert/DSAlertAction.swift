import SwiftUI

// MARK: - DSAlertAction
/// DSAlert 하단 버튼의 추상 모델
///
/// 사용법:
/// ```
/// DSAlertAction.primary("로그아웃") { store.send(.alert(.logoutConfirmed)) }
/// DSAlertAction.secondary("아니요") { store.send(.alert(.dismissed)) }
/// ```

public struct DSAlertAction: Identifiable {
    public enum Style: Sendable {
        /// 강조 액션 — gray500 배경 + 흰 글씨 (기본 confirm)
        case primary
        /// 보조 액션 — gray3 배경 + gray500 글씨 (취소/아니요)
        case secondary
        /// 위험 액션 — main(주황) 배경 + 흰 글씨 (계정 삭제 등)
        case destructive
    }

    public let id = UUID()
    public let title: String
    public let style: Style
    public let handler: () -> Void

    public init(
        title: String,
        style: Style = .primary,
        handler: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

// MARK: - Convenience factories

public extension DSAlertAction {
    static func primary(
        _ title: String,
        action: @escaping () -> Void
    ) -> DSAlertAction {
        DSAlertAction(title: title, style: .primary, handler: action)
    }

    static func secondary(
        _ title: String,
        action: @escaping () -> Void
    ) -> DSAlertAction {
        DSAlertAction(title: title, style: .secondary, handler: action)
    }

    static func destructive(
        _ title: String,
        action: @escaping () -> Void
    ) -> DSAlertAction {
        DSAlertAction(title: title, style: .destructive, handler: action)
    }
}

// MARK: - Style → Color tokens

extension DSAlertAction.Style {
    var background: Color {
        switch self {
        case .primary: return .gray500
        case .secondary: return .gray3
        case .destructive: return .main
        }
    }

    var foreground: Color {
        switch self {
        case .primary, .destructive: return .mainWhite
        case .secondary: return .gray500
        }
    }
}
