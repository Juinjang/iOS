import ComposableArchitecture
import Splash
import SwiftUI

@main
struct JuinjangApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView(
                store: Store(initialState: SplashFeature.State()) {
                    SplashFeature()
                }
            )
        }
    }
}
