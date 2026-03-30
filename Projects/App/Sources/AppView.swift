import ComposableArchitecture
import Home
import Login
import Onboarding
import Splash
import SwiftUI

public struct AppView: View {
    @Perception.Bindable public var store: StoreOf<AppFeature>

    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            if let store = store.scope(state: \.splash, action: \.splash) {
                SplashView(store: store)
            } else if let store = store.scope(state: \.onboarding, action: \.onboarding) {
                OnboardingView(store: store)
            } else if let store = store.scope(state: \.login, action: \.login) {
                LoginView(store: store)
            } else if let store = store.scope(state: \.home, action: \.home) {
                HomeView(store: store)
            }
        }
    }
}
