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

                    pencilShopView
                        .sectionDivider(.top)
                    legalSection
                        .sectionDivider(.top)
                    logoutView
                        .sectionDivider(.top)
                    accountDeleteView
                        .sectionDivider(.top)

                    Spacer(minLength: 20)
                }
            }
            .scrollDismissesKeyboard(.never)
        }
        .background(Color.mainWhite)
        .onAppear { store.send(.view(.onAppear)) }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

// MARK: - Profile

extension SettingView {
    @ViewBuilder
    var profileSection: some View {
        VStack(spacing: 8) {
            profileImage
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

    @ViewBuilder
    private var profileImage: some View {
        if let urlString = store.imageURL, let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Image.profileImage
                    .resizable()
                    .scaledToFill()
            }
        } else {
            Image.profileImage
                .resizable()
                .scaledToFill()
        }
    }
}

// MARK: - Account info

extension SettingView {
    @ViewBuilder
    var accountInfoSection: some View {
        VStack(alignment: .leading, spacing: 28) {
            EditableProfileFieldView(
                config: .nickname,
                savedValue: store.nickname,
                mode: store.nicknameField.mode,
                input: $store.nicknameField.input.sending(\.view.nicknameTextChanged),
                onButtonTap: { store.send(.view(.nicknameFieldButtonTapped)) }
            )

            EditableProfileFieldView(
                config: .intro,
                savedValue: store.oneLineIntroduction,
                mode: store.introField.mode,
                input: $store.introField.input.sending(\.view.introTextChanged),
                onButtonTap: { store.send(.view(.introFieldButtonTapped)) }
            )

            loginInfoView
        }
    }

    @ViewBuilder
    var loginInfoView: some View {
        VStack(alignment: .leading, spacing: 10) {
            DSText("로그인 정보")
                .style(.body2)
                .textColor(.gray400)

            HStack(spacing: 8) {
                providerIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)

                DSText(store.email)
                    .style(.body)
                    .textColor(.gray500)
            }
        }
    }

    private var providerIcon: Image {
        switch store.provider {
        case .apple: return .appleLogo
        case .kakao, .unknown: return .kakao
        }
    }
}

// MARK: - Menu rows

extension SettingView {
    var pencilShopView: some View {
        menuView(
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
    var legalSection: some View {
        VStack(spacing: 0) {
            menuView(
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

            menuView(
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

    func menuView(
        icon: AnyView? = nil,
        title: String,
        titleColor: Color = .gray500,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    icon
                }

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
}

// MARK: - Footer rows

extension SettingView {
    var logoutView: some View {
        menuView(title: "로그아웃", titleColor: .main) {
            store.send(.view(.logoutButtonTapped))
        }
    }

    var accountDeleteView: some View {
        menuView(title: "계정 삭제하기", titleColor: .gray400) {
            store.send(.view(.accountDeleteButtonTapped))
        }
    }
}

#Preview("Setting") {
    SettingView(
        store: Store(initialState: SettingFeature.State()) {
            SettingFeature()
        }
    )
}
