import ComposableArchitecture
import Common
import Dependency
import Foundation
import Model

@Reducer
public struct SettingFeature: Sendable {

    // MARK: - Navigation Path

    @Reducer(state: .equatable)
    public enum Path {
        case termsList(TermsListFeature)
        case termsDetail(TermsDetailFeature)
        case qna(QnAFeature)
    }

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
                // mode/input 변경은 응답 처리 시점에. 실패 시 입력 보존.
                return .save(input)
            case .editing, .validationFailed, .duplicate:
                input = savedValue
                mode = .beforeEdit
                return .cancelled
            }
        }

        /// 저장 성공 시 호출 — 편집 상태 초기화
        public mutating func resetAfterSaveSuccess() {
            mode = .beforeEdit
            input = ""
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
        public var imageURL: String?
        public var provider: AuthProvider

        public var nicknameField: FieldEditState
        public var introField: FieldEditState

        public var pickedImageData: Data?
        public var isUploadingImage: Bool

        public var path: StackState<Path.State>

        @Presents public var alert: AlertState<Action.Alert>?

        public init(
            nickname: String = "",
            email: String = "",
            oneLineIntroduction: String = "",
            imageURL: String? = nil,
            provider: AuthProvider = .unknown,
            path: StackState<Path.State> = StackState()
        ) {
            self.nickname = nickname
            self.email = email
            self.oneLineIntroduction = oneLineIntroduction
            self.imageURL = imageURL
            self.provider = provider
            self.nicknameField = FieldEditState()
            self.introField = FieldEditState()
            self.pickedImageData = nil
            self.isUploadingImage = false
            self.path = path
        }
    }

    public enum Action {
        case view(View)
        case alert(PresentationAction<Alert>)
        case path(StackActionOf<Path>)

        case profileLoaded(Result<UserProfile, JuinjangError>)
        case nicknameSaveResponse(Result<String, JuinjangError>)
        case introSaveResponse(Result<String, JuinjangError>)
        case profileImageUploadResponse(Result<String, JuinjangError>)
        case logoutResponse(Result<Void, JuinjangError>)

        @CasePathable
        public enum View: Equatable {
            case onAppear
            case backButtonTapped
            case profileImagePicked(Data)
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

        public enum Alert: Equatable { }
    }

    @Dependency(\.userClient) var userClient

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { send in
                    await send(.profileLoaded(
                        Result {
                            try await userClient.fetchMyProfile()
                        }
                        .mapToJuinjangError()
                    ))
                }

            case let .profileLoaded(.success(profile)):
                state.nickname = profile.nickname
                state.email = profile.email
                state.oneLineIntroduction = profile.introduction ?? ""
                state.imageURL = profile.imageURL
                state.provider = profile.provider
                return .none

            case .profileLoaded(.failure):
                state.alert = .profileLoadFailed
                return .none

            // MARK: - Nickname

            case .view(.nicknameFieldButtonTapped):
                let result = state.nicknameField.handleButtonTap(savedValue: state.nickname)
                if case let .save(newValue) = result {
                    return .run { send in
                        await send(.nicknameSaveResponse(
                            Result {
                                try await userClient.updateNickname(newValue)
                                return newValue
                            }
                            .mapToJuinjangError()
                        ))
                    }
                }
                return .none

            case let .view(.nicknameTextChanged(text)):
                state.nicknameField.handleTextChanged(
                    text,
                    savedValue: state.nickname,
                    maxCount: State.nicknameMaxCount
                )
                return .none

            case let .nicknameSaveResponse(.success(newValue)):
                state.nickname = newValue
                state.nicknameField.resetAfterSaveSuccess()
                return .none

            case let .nicknameSaveResponse(.failure(error)):
                if error.isNicknameDuplicate {
                    state.nicknameField.mode = .duplicate
                } else {
                    state.alert = .nicknameUpdateFailed
                    // mode/input은 .completed로 유지 → 사용자 재시도 가능
                }
                return .none

            // MARK: - Intro

            case .view(.introFieldButtonTapped):
                let result = state.introField.handleButtonTap(savedValue: state.oneLineIntroduction)
                if case let .save(newValue) = result {
                    return .run { send in
                        await send(.introSaveResponse(
                            Result {
                                try await userClient.updateIntroduction(newValue)
                                return newValue
                            }
                            .mapToJuinjangError()
                        ))
                    }
                }
                return .none

            case let .view(.introTextChanged(text)):
                state.introField.handleTextChanged(
                    text,
                    savedValue: state.oneLineIntroduction,
                    maxCount: State.introMaxCount
                )
                return .none

            case let .introSaveResponse(.success(newValue)):
                state.oneLineIntroduction = newValue
                state.introField.resetAfterSaveSuccess()
                return .none

            case .introSaveResponse(.failure):
                state.alert = .introUpdateFailed
                // mode/input은 .completed로 유지 → 사용자 재시도 가능
                return .none

            // MARK: - Profile image

            case let .view(.profileImagePicked(data)):
                state.pickedImageData = data
                state.isUploadingImage = true
                return .run { send in
                    await send(.profileImageUploadResponse(
                        Result {
                            try await userClient.uploadProfileImage(data)
                        }
                        .mapToJuinjangError()
                    ))
                }

            case let .profileImageUploadResponse(.success(url)):
                state.imageURL = url
                state.pickedImageData = nil
                state.isUploadingImage = false
                return .none

            case .profileImageUploadResponse(.failure):
                state.pickedImageData = nil
                state.isUploadingImage = false
                state.alert = .profileImageUploadFailed
                return .none

            // MARK: - Logout

            case .view(.logoutButtonTapped):
                return .run { send in
                    await send(.logoutResponse(
                        Result {
                            try await userClient.logout()
                        }
                        .mapToJuinjangError()
                    ))
                }

            case .logoutResponse(.success):
                print("[SettingFeature] logout success")
                return .none

            case .logoutResponse(.failure):
                state.alert = .logoutFailed
                return .none

            // MARK: - Navigation pushes

            case .view(.termsButtonTapped):
                state.path.append(.termsList(TermsListFeature.State()))
                return .none

            case .view(.qnaButtonTapped):
                state.path.append(.qna(QnAFeature.State()))
                return .none

            // MARK: - Path delegate handling

            case let .path(.element(_, .termsList(.delegate(.documentSelected(doc))))):
                state.path.append(.termsDetail(TermsDetailFeature.State(document: doc)))
                return .none

            case .path:
                return .none

            // MARK: - Other view actions (print only)

            case let .view(viewAction):
                print("[SettingFeature] \(viewAction)")
                return .none

            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .forEach(\.path, action: \.path)
    }
}

// MARK: - Helpers

private extension Result where Success: Sendable, Failure == Error {
    func mapToJuinjangError() -> Result<Success, JuinjangError> {
        mapError { ($0 as? JuinjangError) ?? .clientError($0.localizedDescription) }
    }
}

private extension JuinjangError {
    /// 닉네임 중복 (서버 code "NICKNAME4002")
    var isNicknameDuplicate: Bool {
        if case let .unknown(code, _) = self, code == "NICKNAME4002" {
            return true
        }
        return false
    }
}

// MARK: - Alert presets

private extension AlertState where Action == SettingFeature.Action.Alert {
    static var profileLoadFailed: Self {
        .init(
            title: { TextState("주인장") },
            message: { TextState("프로필 정보를 불러오지 못했어요") }
        )
    }

    static var nicknameUpdateFailed: Self {
        .init(
            title: { TextState("주인장") },
            message: { TextState("닉네임 변경에 실패했어요") }
        )
    }

    static var introUpdateFailed: Self {
        .init(
            title: { TextState("주인장") },
            message: { TextState("한줄소개 변경에 실패했어요") }
        )
    }

    static var logoutFailed: Self {
        .init(
            title: { TextState("주인장") },
            message: { TextState("로그아웃에 실패했어요\n다시 시도해주세요") }
        )
    }

    static var profileImageUploadFailed: Self {
        .init(
            title: { TextState("주인장") },
            message: { TextState("프로필 사진 업로드에 실패했어요") }
        )
    }
}
