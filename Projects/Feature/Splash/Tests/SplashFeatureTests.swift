import ComposableArchitecture
import Testing
@testable import Splash
@testable import SplashTesting

@MainActor
struct SplashFeatureTests {

    @Test
    func onAppear() async {
        let store = TestStore(
            initialState: SplashFeature.State()
        ) {
            SplashFeature()
        }

        await store.send(.view(.onAppear))
    }
}
