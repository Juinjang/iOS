import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SettingView: View {
    @Bindable var store: StoreOf<SettingFeature>

    public init(store: StoreOf<SettingFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            DSNavigationBar()
                .title("설정")
                .leftItems([.pop])
                .onAction { action in
                    if case .popButtonTap = action {
                        store.send(.view(.backButtonTapped))
                    }
                }

            ScrollView {
                VStack(spacing: 0) {
                    profileSection

                    accountInfoSection
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, 28)

                    thickSeparator

                    pencilShopRow

                    thickSeparator

                    legalSection

                    thickSeparator

                    logoutRow

                    thickSeparator

                    accountDeleteRow

                    Spacer(minLength: 20)
                }
            }
        }
        .background(Color.mainWhite)
        .onAppear { store.send(.view(.onAppear)) }
    }

    // MARK: - Profile

    @ViewBuilder
    private var profileSection: some View {
        VStack(spacing: 8) {
            Image.profileImage
                .resizable()
                .scaledToFill()
                .frame(width: 66, height: 66)
                .clipShape(Circle())

            Button {
                store.send(.view(.editProfileButtonTapped))
            } label: {
                DSText("수정")
                    .style(.body2)
                    .textColor(.main)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 28)
    }

    // MARK: - Account info

    @ViewBuilder
    private var accountInfoSection: some View {
        VStack(alignment: .leading, spacing: 28) {
            editableRow(
                title: "닉네임",
                value: store.nickname,
                placeholder: "닉네임을 입력해 보세요"
            ) {
                store.send(.view(.nicknameEditButtonTapped))
            }

            editableRow(
                title: "한줄소개",
                value: store.oneLineIntroduction,
                placeholder: "한줄소개를 입력해 보세요"
            ) {
                store.send(.view(.oneLineIntroEditButtonTapped))
            }

            loginInfoRow
        }
    }

    @ViewBuilder
    private func editableRow(
        title: String,
        value: String,
        placeholder: String,
        action: @escaping () -> Void
    ) -> some View {
        HStack(alignment: .bottom, spacing: 8) {
            VStack(alignment: .leading, spacing: 10) {
                DSText(title)
                    .style(.body2)
                    .textColor(.gray400)

                if value.isEmpty {
                    DSText(placeholder)
                        .style(.body2)
                        .textColor(.gray300)
                } else {
                    DSText(value)
                        .style(.body)
                        .textColor(.gray500)
                }
            }

            Spacer()

            Button(action: action) {
                DSText("변경")
                    .style(.body2)
                    .textColor(.mainWhite)
                    .frame(width: 64, height: 29)
                    .background(Color.gray450)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var loginInfoRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            DSText("로그인 정보")
                .style(.body2)
                .textColor(.gray400)

            HStack(spacing: 8) {
                Image.kakao
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)

                DSText(store.email)
                    .style(.body)
                    .textColor(.gray500)
            }
        }
    }

    // MARK: - Menus

    private var thickSeparator: some View {
        Color.gray100.frame(height: 4)
    }

    private var pencilShopRow: some View {
        menuRow(
            icon: AnyView(
                Image.pencil
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            ),
            title: "연필상점"
        ) {
            store.send(.view(.pencilShopButtonTapped))
        }
    }

    @ViewBuilder
    private var legalSection: some View {
        VStack(spacing: 0) {
            menuRow(
                icon: AnyView(
                    Image.documentText
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                ),
                title: "약관 및 정책"
            ) {
                store.send(.view(.termsButtonTapped))
            }

            menuRow(
                icon: AnyView(
                    Image.qna
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                ),
                title: "자주 묻는 질문"
            ) {
                store.send(.view(.qnaButtonTapped))
            }
        }
    }

    private func menuRow(
        icon: AnyView,
        title: String,
        titleColor: Color = .gray500,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                icon

                DSText(title)
                    .style(.title)
                    .textColor(titleColor)

                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Logout / Account delete

    private var logoutRow: some View {
        Button {
            store.send(.view(.logoutButtonTapped))
        } label: {
            HStack {
                DSText("로그아웃")
                    .style(.title)
                    .textColor(.main)

                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
    }

    private var accountDeleteRow: some View {
        Button {
            store.send(.view(.accountDeleteButtonTapped))
        } label: {
            HStack {
                DSText("계정 삭제하기")
                    .style(.title)
                    .textColor(.gray400)

                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Setting") {
    SettingView(
        store: Store(initialState: SettingFeature.State()) {
            SettingFeature()
        }
    )
}
