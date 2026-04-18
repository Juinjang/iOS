import SwiftUI

import Dependency
import Splash

import ComposableArchitecture

@main
struct SplashExampleApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView(
                store: Store(initialState: SplashFeature.State()) {
                    SplashFeature()
                } withDependencies: {
                    $0.userDefaultsClient = .testValue
                    $0.appVersionClient = .testValue
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
            $0.appVersionClient = AppVersionClient(
                latestVersion: { "1.0.0" },
                currentVersion: { "1.0.0" }
            )
        }
    )
}

#Preview("업데이트 팝업") {
    SplashView(
        store: Store(initialState: SplashFeature.State(showUpdatePopup: true)) {
            SplashFeature()
        } withDependencies: {
            $0.userDefaultsClient = .testValue
            $0.appVersionClient = AppVersionClient(
                latestVersion: { "1.0.0" },
                currentVersion: { "1.0.0" }
            )
        }
    )
}
