import ComposableArchitecture
import Home
import Login
import Onboarding
import Splash
import SwiftUI

public struct AppView: View {
    @Bindable public var store: StoreOf<AppFeature>

    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            if let store = store.scope(state: \.splash, action: \.splash) {
                SplashView(store: store)
                    .transition(.opacity)
            }
            
            if let store = store.scope(state: \.onboarding, action: \.onboarding) {
                OnboardingView(store: store)
                    .transition(.opacity)
            }
            
            if let store = store.scope(state: \.login, action: \.login) {
                LoginView(store: store)
                    .transition(.opacity)
            }
            
            if let store = store.scope(state: \.home, action: \.home) {
                HomeView(store: store)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: store.activeScreen)
    }
}
