import ComposableArchitecture
import DesignSystem
import SwiftUI

@ViewAction(for: SplashFeature.self)
public struct SplashView: View {

    @Bindable public var store: StoreOf<SplashFeature>

    public init(store: StoreOf<SplashFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("Splash")
        }
        .onAppear { send(.onAppear) }
    }
}

#Preview {
    SplashView(
        store: Store(initialState: SplashFeature.State()) {
            SplashFeature()
        }
    )
}
