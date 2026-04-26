import ComposableArchitecture
import Foundation

@Reducer
public struct SettingFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public var nickname: String
        public var email: String
        public var oneLineIntroduction: String

        public init(
            nickname: String = "땡땡",
            email: String = "juinjang@daum.net",
            oneLineIntroduction: String = ""
        ) {
            self.nickname = nickname
            self.email = email
            self.oneLineIntroduction = oneLineIntroduction
        }
    }

    public enum Action {
        case view(View)

        public enum View: Equatable {
            case onAppear
            case backButtonTapped
            case editProfileButtonTapped
            case nicknameEditButtonTapped
            case oneLineIntroEditButtonTapped
            case pencilShopButtonTapped
            case termsButtonTapped
            case qnaButtonTapped
            case logoutButtonTapped
            case accountDeleteButtonTapped
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case let .view(viewAction):
                print("[SettingFeature] \(viewAction)")
                return .none
            }
        }
    }
}
