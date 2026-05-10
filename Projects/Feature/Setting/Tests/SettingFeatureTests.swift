import ComposableArchitecture
import Testing
@testable import Setting
@testable import SettingTesting

@MainActor
struct SettingFeatureTests {

    @Test
    func onAppear() async {
        let store = TestStore(
            initialState: SettingFeature.State()
        ) {
            SettingFeature()
        }

        await store.send(.onAppear)
    }
}
