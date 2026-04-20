import SwiftUI

import Dependency
import Splash
import SplashTesting

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
                    $0.appVersionClient = MockSplashClient.updatePopupMock
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
            $0.appVersionClient = MockSplashClient.splashMock
        }
    )
}

#Preview("업데이트 팝업") {
    SplashView(
        store: Store(initialState: SplashFeature.State(showUpdatePopup: true)) {
            SplashFeature()
        } withDependencies: {
            $0.userDefaultsClient = .testValue
            $0.appVersionClient = MockSplashClient.updatePopupMock
        }
    )
}
