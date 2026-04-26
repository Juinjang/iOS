import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SettingView: View {
    @Bindable var store: StoreOf<SettingFeature>

    private enum FocusedField: Hashable {
        case nickname
        case intro
    }

    @FocusState private var focusedField: FocusedField?

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
            .scrollDismissesKeyboard(.never)
        }
        .background(Color.mainWhite)
        .onAppear { store.send(.view(.onAppear)) }
        .onChange(of: store.nicknameField.mode) { _, mode in
            syncFocus(for: .nickname, mode: mode)
        }
        .onChange(of: store.introField.mode) { _, mode in
            syncFocus(for: .intro, mode: mode)
        }
    }

    private func syncFocus(for field: FocusedField, mode: SettingFeature.FieldEditState.Mode) {
        if mode == .beforeEdit {
            if focusedField == field { focusedField = nil }
        } else {
            focusedField = field
        }
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
            editableField(
                title: "닉네임",
                savedValue: store.nickname,
                defaultPlaceholder: "닉네임을 입력해 보세요",
                editingPlaceholder: "8자 이내",
                warningText: "닉네임은 8자 이내로 입력해 주세요.",
                duplicateText: "동일한 닉네임이 존재해요",
                field: store.nicknameField,
                focusValue: .nickname,
                textBinding: Binding(
                    get: { store.nicknameField.input },
                    set: { store.send(.view(.nicknameTextChanged($0))) }
                ),
                buttonAction: {
                    if focusedField != nil { focusedField = nil }
                    store.send(.view(.nicknameFieldButtonTapped))
                }
            )

            editableField(
                title: "한줄소개",
                savedValue: store.oneLineIntroduction,
                defaultPlaceholder: "한줄소개를 입력해 보세요",
                editingPlaceholder: "20자 이내",
                warningText: "20자 이내로 입력해 주세요.",
                duplicateText: nil,
                field: store.introField,
                focusValue: .intro,
                textBinding: Binding(
                    get: { store.introField.input },
                    set: { store.send(.view(.introTextChanged($0))) }
                ),
                buttonAction: {
                    if focusedField != nil { focusedField = nil }
                    store.send(.view(.introFieldButtonTapped))
                }
            )

            loginInfoRow
        }
    }

    @ViewBuilder
    private func editableField(
        title: String,
        savedValue: String,
        defaultPlaceholder: String,
        editingPlaceholder: String,
        warningText: String,
        duplicateText: String?,
        field: SettingFeature.FieldEditState,
        focusValue: FocusedField,
        textBinding: Binding<String>,
        buttonAction: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 4.5) {
            HStack(alignment: .bottom, spacing: 8) {
                VStack(alignment: .leading, spacing: 9.5) {
                    DSText(title)
                        .style(.body2)
                        .textColor(.gray400)

                    Group {
                        if field.mode == .beforeEdit {
                            if savedValue.isEmpty {
                                DSText(defaultPlaceholder)
                                    .style(.body2)
                                    .textColor(.gray300)
                            } else {
                                DSText(savedValue)
                                    .style(.body)
                                    .textColor(.gray500)
                            }
                        } else {
                            TextField(
                                "",
                                text: textBinding,
                                prompt: Text(editingPlaceholder)
                                    .foregroundStyle(Color.gray300)
                                    .font(DSFontStyle.body2.font)
                            )
                            .font(DSFontStyle.body.font)
                            .foregroundStyle(Color.gray500)
                            .focused($focusedField, equals: focusValue)
                        }
                    }
                    .frame(height: 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer()

                Button(action: buttonAction) {
                    DSText(buttonTitle(for: field.mode))
                        .style(.body2)
                        .textColor(.mainWhite)
                        .frame(width: 64, height: 29)
                        .background(buttonBackground(for: field.mode))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }

            bottomLine(for: field.mode)

            if let warning = warningMessage(
                for: field.mode,
                warningText: warningText,
                duplicateText: duplicateText
            ) {
                HStack(spacing: 3) {
                    Image.warn
                        .resizable()
                        .frame(width: 16, height: 16)

                    DSText(warning)
                        .style(.body2)
                        .textColor(.main)
                }
            }
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

    // MARK: - Button helpers

    private func buttonTitle(for mode: SettingFeature.FieldEditState.Mode) -> String {
        switch mode {
        case .beforeEdit: return "변경"
        case .completed: return "저장"
        case .editing, .validationFailed, .duplicate: return "취소"
        }
    }

    private func buttonBackground(for mode: SettingFeature.FieldEditState.Mode) -> Color {
        switch mode {
        case .completed: return .main
        default: return .gray450
        }
    }

    private func bottomLine(for mode: SettingFeature.FieldEditState.Mode) -> some View {
        let color: Color
        switch mode {
        case .beforeEdit:
            color = .clear
        case .validationFailed, .duplicate:
            color = .main
        case .editing, .completed:
            color = .stroke
        }
        return color.frame(height: 1)
    }

    private func warningMessage(
        for mode: SettingFeature.FieldEditState.Mode,
        warningText: String,
        duplicateText: String?
    ) -> String? {
        switch mode {
        case .validationFailed: return warningText
        case .duplicate: return duplicateText
        default: return nil
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
