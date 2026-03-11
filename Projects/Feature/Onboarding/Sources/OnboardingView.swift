import ComposableArchitecture
import DesignSystem
import SwiftUI

@ViewAction(for: OnboardingFeature.self)
public struct OnboardingView: View {

    @Bindable public var store: StoreOf<OnboardingFeature>

    public init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("Onboarding")
        }
        .onAppear { send(.onAppear) }
    }
}
