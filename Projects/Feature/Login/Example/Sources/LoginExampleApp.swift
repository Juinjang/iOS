import ComposableArchitecture
import Login
import SwiftUI

@main
struct LoginExampleApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(
                store: Store(initialState: LoginFeature.State()) {
                    LoginFeature()
                }
            )
        }
    }
}

// MARK: - Previews

#Preview("Login") {
    LoginView(
        store: Store(initialState: LoginFeature.State()) {
            LoginFeature()
        }
    )
}
