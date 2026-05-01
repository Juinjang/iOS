import SwiftUI

// MARK: - DSAlert
/// 디자인시스템 표준 알림 컨테이너
///
/// 표시는 `.dsAlert(item:content:)` modifier가 담당하므로,
/// `DSAlert` 자체는 흰 컨테이너 + 헤더 + 본문 + 버튼만 책임집니다.
///
/// 사용법:
/// ```
/// .dsAlert(item: $store.scope(state: \.alert, action: \.alert)) { state in
///     DSAlert(
///         title: state.nickname,
///         titleColor: .main,
///         subtitle: state.email,
///         message: "계정에서 로그아웃할까요?",
///         actions: [
///             .secondary("아니요") { store.send(.alert(.dismissed)) },
///             .primary("로그아웃") { store.send(.alert(.logoutConfirmed)) }
///         ]
///     )
/// }
/// ```

public struct DSAlert<Content: View>: View {
    private let title: String?
    private let titleColor: Color
    private let subtitle: String?
    private let message: String?
    private let actions: [DSAlertAction]
    private let content: Content

    public init(
        title: String? = nil,
        titleColor: Color = .main,
        subtitle: String? = nil,
        message: String? = nil,
        actions: [DSAlertAction],
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.titleColor = titleColor
        self.subtitle = subtitle
        self.message = message
        self.actions = actions
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            headerSection
                .padding(.top, 30)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)

            buttonRow
                .padding(.top, 30)
                .padding(.horizontal, 12)
                .padding(.bottom, 13)
        }
        .background(Color.mainWhite)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Header

    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: 0) {
            if let title {
                DSText(title)
                    .style(.bodyLarge)         // medium 18 (develop 매칭)
                    .textColor(titleColor)
                    .textAlignment(.center)
            }

            if let subtitle {
                DSText(subtitle)
                    .style(.body)              // medium 16 (develop 매칭)
                    .textColor(.gray400)
                    .textAlignment(.center)
                    .padding(.top, title == nil ? 0 : 4)
            }

            if let message {
                DSText(message)
                    .style(.bodyLarge)         // medium 18 (develop 매칭)
                    .textColor(.gray600)
                    .textAlignment(.center)
                    .padding(.top, (title == nil && subtitle == nil) ? 0 : 16)
            }

            content
                .padding(.top, hasAnyHeaderText ? 16 : 0)
        }
    }

    private var hasAnyHeaderText: Bool {
        title != nil || subtitle != nil || message != nil
    }

    // MARK: - Buttons

    @ViewBuilder
    private var buttonRow: some View {
        HStack(spacing: 8) {
            ForEach(actions) { action in
                DSAlertButton(action: action)
            }
        }
        .frame(height: 52)
    }
}

// MARK: - Convenience initializer (no custom content)

public extension DSAlert where Content == EmptyView {
    init(
        title: String? = nil,
        titleColor: Color = .main,
        subtitle: String? = nil,
        message: String? = nil,
        actions: [DSAlertAction]
    ) {
        self.init(
            title: title,
            titleColor: titleColor,
            subtitle: subtitle,
            message: message,
            actions: actions
        ) { EmptyView() }
    }
}

// MARK: - Internal button view

private struct DSAlertButton: View {
    let action: DSAlertAction

    var body: some View {
        Button(action: action.handler) {
            DSText(action.title)
                .style(.title)
                .textColor(action.style.foreground)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(action.style.background)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("로그아웃") {
    Color.gray.opacity(0.1)
        .ignoresSafeArea()
        .overlay {
            DSAlert(
                title: "땡땡",
                titleColor: .main,
                subtitle: "juinjang@daum.net",
                message: "계정에서 로그아웃할까요?",
                actions: [
                    .secondary("아니요") {},
                    .primary("로그아웃") {}
                ]
            )
            .padding(.horizontal, 24)
        }
}

#Preview("계정 삭제 (destructive)") {
    Color.gray.opacity(0.1)
        .ignoresSafeArea()
        .overlay {
            DSAlert(
                title: "정말 계정을 삭제하시겠어요?",
                titleColor: .gray600,
                message: "삭제된 계정은 복구할 수 없습니다.",
                actions: [
                    .secondary("아니요") {},
                    .destructive("삭제") {}
                ]
            )
            .padding(.horizontal, 24)
        }
}

#Preview("단일 버튼 (안내)") {
    Color.gray.opacity(0.1)
        .ignoresSafeArea()
        .overlay {
            DSAlert(
                title: "업데이트 완료",
                titleColor: .main,
                message: "최신 버전으로 업데이트되었습니다.",
                actions: [
                    .primary("확인") {}
                ]
            )
            .padding(.horizontal, 24)
        }
}
