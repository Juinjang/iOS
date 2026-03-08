import ComposableArchitecture
import Dependency
import Model

@Reducer
public struct SplashFeature {

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
        }
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none
            }
        }
    }
}
