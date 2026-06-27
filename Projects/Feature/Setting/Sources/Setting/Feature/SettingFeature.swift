import ComposableArchitecture
import Common
import Dependency
import Foundation
import Model

// MARK: - SettingFeature
/// 설정 화면 reducer.
/// **본체엔 동작에 필수적인 것만**: State, Action, body, init, dependencies.
///
/// 별도 파일로 분리된 모델성 항목:
///   - `+Path.swift`       : 네비게이션 destination 모델
///   - `+Alert.swift`      : SettingAlert (alert state 모델)
///   - `+ThrottleID.swift` : API throttle 식별자

@Reducer
public struct SettingFeature: Sendable {

    // MARK: - State

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

        @Presents public var alert: SettingAlert?
        @Presents public var qnaSheet: QnAFeature.State?
        @Presents public var termsSheet: TermsListFeature.State?
        @Presents public var accountDeleteFlow: AccountDeleteFlowFeature.State?

        public init(
            nickname: String = "",
            email: String = "",
            oneLineIntroduction: String = "",
            imageURL: String? = nil,
            provider: AuthProvider = .unknown
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
        }
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

    // MARK: - Action

    public enum Action: Sendable {
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

        case alert(PresentationAction<Alert>)
        case qnaSheet(PresentationAction<QnAFeature.Action>)
        case termsSheet(PresentationAction<TermsListFeature.Action>)
        case accountDeleteFlow(PresentationAction<AccountDeleteFlowFeature.Action>)

        case profileLoaded(Result<UserProfile, JuinjangError>)
        case nicknameSaveResponse(Result<String, JuinjangError>)
        case introSaveResponse(Result<String, JuinjangError>)
        case profileImageUploadResponse(Result<String, JuinjangError>)
        case logoutResponse(Result<Void, JuinjangError>)

        public enum Alert: Equatable, Sendable {
            case logoutConfirmed
        }
    }

    // MARK: - Dependencies

    @Dependency(\.userClient) var userClient

    public init() {}

    // MARK: - Body

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.profileLoaded(
                        Result {
                            try await userClient.fetchMyProfile()
                        }
                        .mapToJuinjangError()
                    ))
                }
                .apiThrottle(id: ThrottleID.profileLoad)

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

            case .nicknameFieldButtonTapped:
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
                    .apiThrottle(id: ThrottleID.nicknameSave)
                }
                return .none

            case let .nicknameTextChanged(text):
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
                }
                return .none

            // MARK: - Intro

            case .introFieldButtonTapped:
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
                    .apiThrottle(id: ThrottleID.introSave)
                }
                return .none

            case let .introTextChanged(text):
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
                return .none

            // MARK: - Profile image

            case let .profileImagePicked(data):
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
                .apiThrottle(id: ThrottleID.profileImageUpload)

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

            // MARK: - Logout (확인 알림 → 확인 시 실제 로그아웃)

            case .logoutButtonTapped:
                state.alert = .logoutConfirm(
                    nickname: state.nickname,
                    email: state.email
                )
                return .none

            case .alert(.presented(.logoutConfirmed)):
                return .run { send in
                    await send(.logoutResponse(
                        Result {
                            try await userClient.logout()
                        }
                        .mapToJuinjangError()
                    ))
                }
                .apiThrottle(id: ThrottleID.logout)

            case .logoutResponse(.success):
                print("[SettingFeature] logout success")
                return .none

            case .logoutResponse(.failure):
                state.alert = .logoutFailed
                return .none

            // MARK: - Account delete (풀스크린 플로우 진입)

            case .accountDeleteButtonTapped:
                state.accountDeleteFlow = AccountDeleteFlowFeature.State(nickname: state.nickname)
                return .none

            case .accountDeleteFlow:
                return .none

            // MARK: - Navigation pushes

            case .termsButtonTapped:
                state.termsSheet = TermsListFeature.State()
                return .none

            case .qnaButtonTapped:
                state.qnaSheet = QnAFeature.State()
                return .none

            case .qnaSheet:
                return .none

            case .termsSheet:
                return .none

            // MARK: - Other view actions

            case .backButtonTapped, .pencilShopButtonTapped:
                return .none

            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert) {
            EmptyReducer()
        }
        .ifLet(\.$qnaSheet, action: \.qnaSheet) {
            QnAFeature()
        }
        .ifLet(\.$termsSheet, action: \.termsSheet) {
            TermsListFeature()
        }
        .ifLet(\.$accountDeleteFlow, action: \.accountDeleteFlow) {
            AccountDeleteFlowFeature()
        }
    }
}

// MARK: - Helpers
/// SettingFeature body에서만 쓰는 작은 외부 타입 확장.

private extension JuinjangError {
    /// 닉네임 중복 (서버 code "NICKNAME4002")
    var isNicknameDuplicate: Bool {
        if case let .unknown(code, _) = self, code == "NICKNAME4002" {
            return true
        }
        return false
    }
}
