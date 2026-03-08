import ComposableArchitecture
import DesignSystem
import SwiftUI

@ViewAction(for: LoginFeature.self)
public struct LoginView: View {

    @Bindable public var store: StoreOf<LoginFeature>

    public init(store: StoreOf<LoginFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("Login")
        }
        .onAppear { send(.onAppear) }
    }
}

#Preview {
    LoginView(
        store: Store(initialState: LoginFeature.State()) {
            LoginFeature()
        }
    )
}
