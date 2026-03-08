import ComposableArchitecture
import Model
import Testing
@testable import Home
@testable import HomeTesting

// MARK: - HomeFeature Tests

@MainActor
struct HomeFeatureTests {

    @Test
    func onAppearLoadsFeed() async {
        let mockPosts = MockHomeData.posts

        let store = TestStore(
            initialState: HomeFeature.State()
        ) {
            HomeFeature()
        } withDependencies: {
            $0.apiClient.fetchHomeFeed = { mockPosts }
        }

        await store.send(.view(.onAppear)) {
            $0.isLoading = true
            $0.errorMessage = nil
        }

        await store.receive(\.feedResponse.success) {
            $0.isLoading = false
            $0.posts = mockPosts
        }
    }

    @Test
    func onAppearHandlesFailure() async {
        let store = TestStore(
            initialState: HomeFeature.State()
        ) {
            HomeFeature()
        } withDependencies: {
            $0.apiClient.fetchHomeFeed = {
                throw NSError(domain: "test", code: -1)
            }
        }

        await store.send(.view(.onAppear)) {
            $0.isLoading = true
            $0.errorMessage = nil
        }

        await store.receive(\.feedResponse.failure) {
            $0.isLoading = false
            $0.errorMessage = "The operation couldn't be completed. (test error -1.)"
        }
    }
}
