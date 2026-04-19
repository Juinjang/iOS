import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct LoginView: View {
    @Bindable var store: StoreOf<LoginFeature>
    
    public init(store: StoreOf<LoginFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("Login")
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
