import DesignSystem
import SwiftUI

// MARK: - 갑자기 Edit 모드일떄만 텍스트뷰 width값 각 text의 간격?이 늘어나는 문제 하나
// - 지금 height값이 너무 커..
//

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

                    // 모드와 무관하게 TextField 한 종류만 렌더링 → view 트리 고정 → 레이아웃 시프트 0.
                    // beforeEdit일 땐 savedValue 보여주면서 disabled (cursor 없음, 키보드 안 뜸).
                    TextField(
                        "",
                        text: textFieldBinding,
                        prompt: Text(currentPlaceholder)
                            .foregroundStyle(Color.gray300)
                            .font(DSFontStyle.body2.font)
                            .kerning(DSFontStyle.body2.letterSpacing)
                    )
                    .font(DSFontStyle.body.font)
                    .foregroundStyle(Color.gray500)
                    .kerning(DSFontStyle.body.letterSpacing)
                    .disabled(mode == .beforeEdit)
                    .focused($isFocused)
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

            HStack(spacing: 3) {
                Image.warn
                    .resizable()
                    .frame(width: 16, height: 16)

                DSText(warningMessage ?? config.warningText)
                    .style(.body2)
                    .textColor(.main)
            }
            .opacity(warningMessage == nil ? 0 : 1)
            .accessibilityHidden(warningMessage == nil)
        }
        .animation(.easeInOut(duration: 0.2), value: mode)   // 변경/취소/저장 전환 부드럽게
        .onChange(of: mode) { _, newMode in
            isFocused = (newMode != .beforeEdit)
        }
    }

    // MARK: - TextField bindings

    /// `mode == .beforeEdit`이면 savedValue를 보여주고, 그 외엔 사용자가 입력하는 input을 보여줌.
    /// disabled 상태일 땐 setter가 호출되지 않으므로 input은 안전하게 보존됨.
    private var textFieldBinding: Binding<String> {
        Binding(
            get: { mode == .beforeEdit ? savedValue : input },
            set: { input = $0 }
        )
    }

    /// 모드별 placeholder 문구. 비어있을 때만 prompt가 노출됨.
    private var currentPlaceholder: String {
        mode == .beforeEdit ? config.defaultPlaceholder : config.editingPlaceholder
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
