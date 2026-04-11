import ComposableArchitecture
import DesignSystem
import Model
import SwiftUI

// MARK: - Home View

@ViewAction(for: HomeFeature.self)
public struct HomeView: View {

    @Bindable public var store: StoreOf<HomeFeature>

    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            DSNavigationBar(style: .center) {
                Image.logo
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
            }
            .leftItems([.setting])
            .rightItems([.record])
            .onAction { action in
                send(.navigationAction(action))
            }

            Spacer()
        }
        .onAppear { send(.onAppear) }
    }
}
