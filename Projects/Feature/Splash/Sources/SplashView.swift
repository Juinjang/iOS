import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SplashView: View {
    @Bindable var store: StoreOf<SplashFeature>

    public init(store: StoreOf<SplashFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            Color.splash
                .ignoresSafeArea()

            DSLottieView(name: "splash60") {
                store.send(.animationCompleted)
            }
            .frame(width: 250, height: 250)
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

#Preview {
    SplashView(
        store: Store(initialState: SplashFeature.State()) {
            SplashFeature()
        }
    )
}
