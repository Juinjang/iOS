import ComposableArchitecture
import Dependency
import Model

// MARK: - Home Feature Reducer

@Reducer
public struct HomeFeature {

    public init() {}

    @Dependency(\.apiClient) var apiClient

    // MARK: - State

    @ObservableState
    public struct State: Equatable {
        public var posts: [Post] = []
        public var isLoading = false
        public var errorMessage: String?

        public init() {}
    }

    // MARK: - Action

    public enum Action: ViewAction {
        case view(View)
        case feedResponse(Result<[Post], Error>)

        @CasePathable
        public enum View {
            case onAppear
            case refreshTapped
        }
    }

    // MARK: - Body

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear), .view(.refreshTapped):
                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    await send(.feedResponse(
                        Result { try await apiClient.fetchHomeFeed() }
                    ))
                }

            case .feedResponse(.success(let posts)):
                state.isLoading = false
                state.posts = posts
                return .none

            case .feedResponse(.failure(let error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            }
        }
    }
}
