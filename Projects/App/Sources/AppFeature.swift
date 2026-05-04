import ComposableArchitecture
import Home
import Login
import Onboarding
import Splash

@Reducer
public struct AppFeature {
    @ObservableState
    public struct State: Equatable {
        public var splash: SplashFeature.State?
        public var onboarding: OnboardingFeature.State?
        public var login: LoginFeature.State?
        public var home: HomeFeature.State?

        public enum ActiveScreen {
            case splash, onboarding, login, home, none
        }

        public var activeScreen: ActiveScreen {
            if splash != nil { return .splash }
            if onboarding != nil { return .onboarding }
            if login != nil { return .login }
            if home != nil { return .home }
            return .none
        }

        public init() {
            self.splash = SplashFeature.State()
        }
    }

    public enum Action {
        case splash(SplashFeature.Action)
        case onboarding(OnboardingFeature.Action)
        case login(LoginFeature.Action)
        case home(HomeFeature.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .splash(.delegate(.navigateTo(let route))):
                state.splash = nil
                switch route {
                case .onboarding:
                    state.onboarding = OnboardingFeature.State()
                case .login:
//                    state.login = LoginFeature.State()
                    state.onboarding = OnboardingFeature.State()
                case .home:
                    state.home = HomeFeature.State()
                }
                return .none
            case .onboarding(.delegate(.navigateToLogin)):
                state.onboarding = nil
                state.login = LoginFeature.State()
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.splash, action: \.splash) { SplashFeature() }
        .ifLet(\.onboarding, action: \.onboarding) { OnboardingFeature() }
        .ifLet(\.login, action: \.login) { LoginFeature() }
        .ifLet(\.home, action: \.home) { HomeFeature() }
    }
}
