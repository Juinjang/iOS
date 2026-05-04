import Foundation

import Dependency

import ComposableArchitecture

// MARK: - OnboardingFeature

@Reducer
public struct OnboardingFeature: Sendable {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public var currentPage: Int = 0
        public var isLoginButtonVisible: Bool = false
        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loginButtonTapped
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case navigateToLogin
        }
    }

    @Dependency(\.userDefaultsClient) var userDefaultsClient

    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.currentPage):
                if state.currentPage == OnboardingPage.allCases.count - 1 {
                    state.isLoginButtonVisible = true
                }
                return .none

            case .binding:
                return .none

            case .loginButtonTapped:
                return .run { send in
                    userDefaultsClient.save(true, forKey: .userStatus)
                    await send(.delegate(.navigateToLogin))
                }

            case .delegate:
                return .none
            }
        }
    }
}
