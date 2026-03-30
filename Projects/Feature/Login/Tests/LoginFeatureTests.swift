import ComposableArchitecture
import Testing
@testable import Login
@testable import LoginTesting

@MainActor
struct LoginFeatureTests {

    @Test
    func onAppear() async {
        let store = TestStore(
            initialState: LoginFeature.State()
        ) {
            LoginFeature()
        }

        await store.send(.view(.onAppear))
    }
}
