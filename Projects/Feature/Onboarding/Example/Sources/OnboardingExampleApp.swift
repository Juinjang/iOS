import ComposableArchitecture
import Onboarding
import SwiftUI

@main
struct OnboardingExampleApp: App {
    var body: some Scene {
        WindowGroup {
            OnboardingView(
                store: Store(initialState: OnboardingFeature.State()) {
                    OnboardingFeature()
                }
            )
        }
    }
}
