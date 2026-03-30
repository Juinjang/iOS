import ComposableArchitecture
import DesignSystem
import Model
import SwiftUI

// MARK: - Home View

@ViewAction(for: HomeFeature.self)
public struct HomeView: View {

    @Perception.Bindable public var store: StoreOf<HomeFeature>

    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("Home")
        }
        .onAppear { send(.onAppear) }
    }
}
