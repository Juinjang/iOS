import ComposableArchitecture
import Dependency
import DesignSystem
import Model

// MARK: - Home Feature Reducer

@Reducer
public struct HomeFeature {

    public init() {}

    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: ViewAction {
        case view(View)

        @CasePathable
        public enum View {
            case onAppear
            case navigationAction(DSNavigationAction)
        }
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none
            case .view(.navigationAction(let action)):
                return handleNavigationAction(action)
            }
        }
    }

    private func handleNavigationAction(_ action: DSNavigationAction) -> Effect<Action> {
        switch action {
        case .settingButtonTap:
            return .none // TODO: 설정 화면 이동
        case .recordButtonTap:
            return .none // TODO: 녹음 화면 이동
        default:
            return .none
        }
    }
}
