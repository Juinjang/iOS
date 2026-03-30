import ComposableArchitecture
import Dependency

@Reducer
public struct SplashFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case view(View)
        case animationCompleted
        case delegate(Delegate)

        public enum View: Equatable {
            case onAppear
        }

        public enum Delegate: Equatable {
            case navigateToOnboarding
            case navigateToLogin
            case navigateToHome
        }
    }

    @Dependency(\.userDefaultsClient) var userDefaultsClient

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none
            case .animationCompleted:
                return .run { send in
                    let userStatus = userDefaultsClient.bool(.userStatus, default: false)
                    let accessToken = (try? userDefaultsClient.string(.accessToken)) ?? ""

                    if !userStatus {
                        await send(.delegate(.navigateToOnboarding))
                    } else if accessToken.isEmpty {
                        await send(.delegate(.navigateToLogin))
                    } else {
                        await send(.delegate(.navigateToHome))
                    }
                }
            case .delegate:
                return .none
            }
        }
    }
}
