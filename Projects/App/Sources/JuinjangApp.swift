import ComposableArchitecture
import Home
import SwiftUI

@main
struct JuinjangApp: App {
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
