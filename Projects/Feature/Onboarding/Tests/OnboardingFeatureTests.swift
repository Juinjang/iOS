import ComposableArchitecture
import Testing
@testable import Onboarding
@testable import OnboardingTesting

@MainActor
struct OnboardingFeatureTests {

    @Test
    func onAppear() async {
        let store = TestStore(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }

        await store.send(.view(.onAppear))
    }
}
