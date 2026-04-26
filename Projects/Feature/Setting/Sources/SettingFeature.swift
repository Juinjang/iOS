import ComposableArchitecture
import Foundation

@Reducer
public struct SettingFeature: Sendable {
    public struct FieldEditState: Equatable {
        public enum ButtonTapResult: Equatable {
            case startedEditing
            case save(String)
            case cancelled
        }

        public var mode: EditableProfileFieldView.Mode
        public var input: String

        public init(mode: EditableProfileFieldView.Mode = .beforeEdit, input: String = "") {
            self.mode = mode
            self.input = input
        }

        public mutating func handleButtonTap(savedValue: String) -> ButtonTapResult {
            switch mode {
            case .beforeEdit:
                input = savedValue
                mode = .editing
                return .startedEditing
            case .completed:
                let toSave = input
                mode = .beforeEdit
                input = ""
                return .save(toSave)
            case .editing, .validationFailed, .duplicate:
                input = savedValue
                mode = .beforeEdit
                return .cancelled
            }
        }

        public mutating func handleTextChanged(
            _ text: String,
            savedValue: String,
            maxCount: Int
        ) {
            guard mode != .beforeEdit else { return }

            input = text

            if text.count > maxCount {
                mode = .validationFailed
            } else if text.isEmpty || text == savedValue {
                mode = .editing
            } else {
                mode = .completed
            }
        }
    }

    @ObservableState
    public struct State: Equatable {
        public static let nicknameMaxCount = 8
        public static let introMaxCount = 20

        public var nickname: String
        public var email: String
        public var oneLineIntroduction: String
        public var nicknameField: FieldEditState
        public var introField: FieldEditState

        public init(
            nickname: String = "땡땡",
            email: String = "juinjang@daum.net",
            oneLineIntroduction: String = ""
        ) {
            self.nickname = nickname
            self.email = email
            self.oneLineIntroduction = oneLineIntroduction
            self.nicknameField = FieldEditState()
            self.introField = FieldEditState()
        }
    }

    public enum Action {
        case view(View)

        @CasePathable
        public enum View: Equatable {
            case onAppear
            case backButtonTapped
            case editProfileButtonTapped
            case nicknameFieldButtonTapped
            case nicknameTextChanged(String)
            case introFieldButtonTapped
            case introTextChanged(String)
            case pencilShopButtonTapped
            case termsButtonTapped
            case qnaButtonTapped
            case logoutButtonTapped
            case accountDeleteButtonTapped
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.nicknameFieldButtonTapped):
                let result = state.nicknameField.handleButtonTap(savedValue: state.nickname)
                logFieldButton(label: "nickname", result: result)
                if case let .save(newValue) = result {
                    state.nickname = newValue
                }
                return .none

            case let .view(.nicknameTextChanged(text)):
                state.nicknameField.handleTextChanged(
                    text,
                    savedValue: state.nickname,
                    maxCount: State.nicknameMaxCount
                )
                return .none

            case .view(.introFieldButtonTapped):
                let result = state.introField.handleButtonTap(savedValue: state.oneLineIntroduction)
                logFieldButton(label: "intro", result: result)
                if case let .save(newValue) = result {
                    state.oneLineIntroduction = newValue
                }
                return .none

            case let .view(.introTextChanged(text)):
                state.introField.handleTextChanged(
                    text,
                    savedValue: state.oneLineIntroduction,
                    maxCount: State.introMaxCount
                )
                return .none

            case let .view(viewAction):
                print("[SettingFeature] \(viewAction)")
                return .none
            }
        }
    }

    private func logFieldButton(label: String, result: FieldEditState.ButtonTapResult) {
        switch result {
        case .startedEditing:
            print("[SettingFeature] \(label) editing started")
        case let .save(value):
            print("[SettingFeature] \(label) save: \(value)")
        case .cancelled:
            print("[SettingFeature] \(label) edit cancelled")
        }
    }
}
