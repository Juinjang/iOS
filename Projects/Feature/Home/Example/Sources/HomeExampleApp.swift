import ComposableArchitecture
import Home
import SwiftUI

@main
struct HomeExampleApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(
                store: Store(initialState: HomeFeature.State()) {
                    HomeFeature()
                }
            )
        }
    }
}

// MARK: - Previews

#Preview("Home") {
    HomeView(
        store: Store(initialState: HomeFeature.State()) {
            HomeFeature()
        }
    )
}
