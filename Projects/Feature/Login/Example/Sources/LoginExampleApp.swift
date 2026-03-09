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
