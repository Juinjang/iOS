import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct OnboardingView: View {

    @Bindable public var store: StoreOf<OnboardingFeature>

    public init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("Onboarding")
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
