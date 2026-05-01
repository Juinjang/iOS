import ComposableArchitecture
import Common
import DesignSystem
import PhotosUI
import SwiftUI

public struct SettingView: View {
    @Bindable var store: StoreOf<SettingFeature>

    @State private var photoPickerItem: PhotosPickerItem?

    public init(store: StoreOf<SettingFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            rootContent
        } destination: { store in
            switch store.case {
            case let .termsList(store):
                TermsListView(store: store)
            case let .termsDetail(store):
                TermsDetailView(store: store)
            case let .marketingNotice(store):
                MarketingNoticeView(store: store)
            case let .qna(store):
                QnAView(store: store)
            }
        }
    }

    @ViewBuilder
    private var rootContent: some View {
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
        .navigationBarHidden(true)
        .onAppear { store.send(.view(.onAppear)) }
        .dsAlert(
            item: Binding(
                get: { store.alert },
                set: { if $0 == nil { store.send(.alert(.dismiss)) } }
            )
        ) { alert in
            settingAlert(alert)
        }
    }

    @ViewBuilder
    private func settingAlert(_ alert: SettingFeature.SettingAlert) -> some View {
        switch alert {
        case let .logoutConfirm(nickname, email):
            DSAlert(
                title: nickname,
                titleColor: .main,
                subtitle: email,
                message: "계정에서 로그아웃할까요?",
                actions: [
                    .secondary("아니요") { store.send(.alert(.dismiss)) },
                    .primary("로그아웃") { store.send(.alert(.presented(.logoutConfirmed))) }
                ]
            )

        case .accountDeleteConfirm:
            DSAlert(
                title: "정말 계정을 삭제하시겠어요?",
                titleColor: .gray600,
                message: "삭제된 계정과 데이터는 복구할 수 없어요.",
                actions: [
                    .secondary("아니요") { store.send(.alert(.dismiss)) },
                    .destructive("삭제") { store.send(.alert(.presented(.accountDeleteConfirmed))) }
                ]
            )

        case .profileLoadFailed:
            DSAlert(
                title: "주인장",
                message: "프로필 정보를 불러오지 못했어요",
                actions: [.primary("확인") { store.send(.alert(.dismiss)) }]
            )

        case .nicknameUpdateFailed:
            DSAlert(
                title: "주인장",
                message: "닉네임 변경에 실패했어요",
                actions: [.primary("확인") { store.send(.alert(.dismiss)) }]
            )

        case .introUpdateFailed:
            DSAlert(
                title: "주인장",
                message: "한줄소개 변경에 실패했어요",
                actions: [.primary("확인") { store.send(.alert(.dismiss)) }]
            )

        case .logoutFailed:
            DSAlert(
                title: "주인장",
                message: "로그아웃에 실패했어요\n다시 시도해주세요",
                actions: [.primary("확인") { store.send(.alert(.dismiss)) }]
            )

        case .profileImageUploadFailed:
            DSAlert(
                title: "주인장",
                message: "프로필 사진 업로드에 실패했어요",
                actions: [.primary("확인") { store.send(.alert(.dismiss)) }]
            )
        }
    }
}

// MARK: - Sections

extension SettingView {
    @ViewBuilder
    var profileSection: some View {
        VStack(spacing: 8) {
            ProfileImageView(
                pickedImageData: store.pickedImageData,
                imageURL: store.imageURL
            )
            .frame(width: 66, height: 66)
            .clipShape(Circle())
            .overlay {
                if store.isUploadingImage {
                    Circle().fill(Color.black.opacity(0.3))
                    ProgressView()
                        .tint(.white)
                }
            }

            ProfileEditPhotoPicker(
                selection: $photoPickerItem,
                onPick: handlePickerSelection
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 28)
    }

    @ViewBuilder
    var accountInfoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
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
            .padding(.top, 20)

            loginInfoView
                .padding(.top, 45)
        }
    }

    var pencilShopView: some View {
        SettingMenuRow(title: "연필상점") {
            store.send(.view(.pencilShopButtonTapped))
        } icon: {
            Image.pencil
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
    }

    @ViewBuilder
    var legalSection: some View {
        VStack(spacing: 0) {
            SettingMenuRow(title: "약관 및 정책") {
                store.send(.view(.termsButtonTapped))
            } icon: {
                Image.documentText
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }

            SettingMenuRow(title: "자주 묻는 질문") {
                store.send(.view(.qnaButtonTapped))
            } icon: {
                Image.qna
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
        }
    }

    var logoutView: some View {
        SettingMenuRow(title: "로그아웃", titleColor: .main) {
            store.send(.view(.logoutButtonTapped))
        }
    }

    var accountDeleteView: some View {
        SettingMenuRow(title: "계정 삭제하기", titleColor: .gray400) {
            store.send(.view(.accountDeleteButtonTapped))
        }
    }
}

// MARK: - Subviews

extension SettingView {
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

// MARK: - Actions

extension SettingView {
    private func handlePickerSelection(_ item: PhotosPickerItem?) {
        guard let item else { return }
        Task { @MainActor in
            guard
                let rawData = try? await item.loadTransferable(type: Data.self),
                let uiImage = UIImage(data: rawData),
                let jpegData = uiImage.jpegData(compressionQuality: 0.2)
            else { return }
            store.send(.view(.profileImagePicked(jpegData)))
            photoPickerItem = nil
        }
    }
}

// MARK: - Previews

#Preview("Setting - 정상 (mock 데이터)") {
    SettingView(
        store: Store(initialState: SettingFeature.State()) {
            SettingFeature()
        }
        // userClient는 자동으로 previewValue 사용 → 닉네임/이메일/한줄소개 채워서 표시
    )
}

#Preview("Setting - 프로필 로드 실패") {
    SettingView(
        store: Store(initialState: SettingFeature.State()) {
            SettingFeature()
        } withDependencies: {
            $0.userClient.fetchMyProfile = {
                throw JuinjangError.unauthorized(nil)
            }
        }
    )
}

#Preview("Setting - 닉네임 중복") {
    SettingView(
        store: Store(initialState: SettingFeature.State()) {
            SettingFeature()
        } withDependencies: {
            $0.userClient.updateNickname = { _ in
                throw JuinjangError.unknown(code: "NICKNAME4002", message: nil)
            }
        }
    )
}

#Preview("Setting - 이미지 업로드 성공") {
    SettingView(
        store: Store(
            initialState: SettingFeature.State(
                nickname: "땡땡",
                email: "juinjang@daum.net",
                oneLineIntroduction: "업로드 직후 상태",
                imageURL: "https://picsum.photos/seed/uploaded/200",
                provider: .kakao
            )
        ) {
            SettingFeature()
        }
    )
}
