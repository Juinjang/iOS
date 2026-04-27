import DesignSystem
import SwiftUI

public struct EditableProfileFieldView: View {
    public enum Mode: Equatable {
        case beforeEdit
        case editing
        case completed
        case validationFailed
        case duplicate
    }

    public struct Config: Sendable {
        public let title: String
        public let defaultPlaceholder: String
        public let editingPlaceholder: String
        public let warningText: String
        public let duplicateText: String?

        public init(
            title: String,
            defaultPlaceholder: String,
            editingPlaceholder: String,
            warningText: String,
            duplicateText: String? = nil
        ) {
            self.title = title
            self.defaultPlaceholder = defaultPlaceholder
            self.editingPlaceholder = editingPlaceholder
            self.warningText = warningText
            self.duplicateText = duplicateText
        }
    }

    private let config: Config
    private let savedValue: String
    private let mode: Mode
    @Binding private var input: String
    private let onButtonTap: () -> Void

    @FocusState private var isFocused: Bool

    public init(
        config: Config,
        savedValue: String,
        mode: Mode,
        input: Binding<String>,
        onButtonTap: @escaping () -> Void
    ) {
        self.config = config
        self.savedValue = savedValue
        self.mode = mode
        self._input = input
        self.onButtonTap = onButtonTap
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4.5) {
            HStack(alignment: .bottom, spacing: 8) {
                VStack(alignment: .leading, spacing: 9.5) {
                    DSText(config.title)
                        .style(.body2)
                        .textColor(.gray400)

                    Group {
                        if mode == .beforeEdit {
                            if savedValue.isEmpty {
                                DSText(config.defaultPlaceholder)
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
                                text: $input,
                                prompt: Text(config.editingPlaceholder)
                                    .foregroundStyle(Color.gray300)
                                    .font(DSFontStyle.body2.font)
                            )
                            .font(DSFontStyle.body.font)
                            .foregroundStyle(Color.gray500)
                            .focused($isFocused)
                        }
                    }
                    .frame(height: 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer()

                Button {
                    if isFocused { isFocused = false }
                    onButtonTap()
                } label: {
                    DSText(buttonTitle)
                        .style(.body2)
                        .textColor(.mainWhite)
                        .frame(width: 64, height: 29)
                        .background(buttonBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }

            bottomLine

            if let warning = warningMessage {
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
        .onChange(of: mode) { _, newMode in
            isFocused = (newMode != .beforeEdit)
        }
    }

    // MARK: - Mode-driven appearance

    private var buttonTitle: String {
        switch mode {
        case .beforeEdit: return "변경"
        case .completed: return "저장"
        case .editing, .validationFailed, .duplicate: return "취소"
        }
    }

    private var buttonBackground: Color {
        mode == .completed ? .main : .gray450
    }

    private var bottomLine: some View {
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

    private var warningMessage: String? {
        switch mode {
        case .validationFailed: return config.warningText
        case .duplicate: return config.duplicateText
        default: return nil
        }
    }
}

// MARK: - Config presets

extension EditableProfileFieldView.Config {
    static let nickname = EditableProfileFieldView.Config(
        title: "닉네임",
        defaultPlaceholder: "닉네임을 입력해 보세요",
        editingPlaceholder: "8자 이내",
        warningText: "닉네임은 8자 이내로 입력해 주세요.",
        duplicateText: "동일한 닉네임이 존재해요"
    )

    static let intro = EditableProfileFieldView.Config(
        title: "한줄소개",
        defaultPlaceholder: "한줄소개를 입력해 보세요",
        editingPlaceholder: "20자 이내",
        warningText: "20자 이내로 입력해 주세요."
    )
}
