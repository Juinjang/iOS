import ComposableArchitecture
import Splash
import SwiftUI

@main
struct SplashExampleApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView(
                store: Store(initialState: SplashFeature.State()) {
                    SplashFeature()
                } withDependencies: {
                    $0.userDefaultsClient = .testValue
                }
            )
        }
    }
}

// MARK: - Previews

#Preview("Splash") {
    SplashView(
        store: Store(initialState: SplashFeature.State()) {
            SplashFeature()
        } withDependencies: {
            $0.userDefaultsClient = .testValue
        }
    )
}
