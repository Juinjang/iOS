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
            splashView
            onboardingView
            loginView
            homeView
        }
        .animation(.easeInOut(duration: 0.3), value: store.activeScreen)
    }

    // MARK: - Screen Views

    @ViewBuilder
    private var splashView: some View {
        if let store = store.scope(state: \.splash, action: \.splash) {
            SplashView(store: store)
                .transition(.opacity)
        }
    }

    @ViewBuilder
    private var onboardingView: some View {
        if let store = store.scope(state: \.onboarding, action: \.onboarding) {
            OnboardingView(store: store)
                .transition(.opacity)
        }
    }

    @ViewBuilder
    private var loginView: some View {
        if let store = store.scope(state: \.login, action: \.login) {
            LoginView(store: store)
                .transition(.opacity)
        }
    }

    @ViewBuilder
    private var homeView: some View {
        if let store = store.scope(state: \.home, action: \.home) {
            HomeView(store: store)
                .transition(.opacity)
        }
    }
}
