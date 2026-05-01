import ComposableArchitecture
import SwiftUI

public struct AccountDeleteFlowView: View {
    let store: StoreOf<AccountDeleteFlowFeature>

    public init(store: StoreOf<AccountDeleteFlowFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            AccountDeleteWarningView(store: store)
                .opacity(store.isShowingReason ? 0 : 1)
                .allowsHitTesting(!store.isShowingReason)

            AccountDeleteReasonView(store: store)
                .opacity(store.isShowingReason ? 1 : 0)
                .allowsHitTesting(store.isShowingReason)
        }
    }
}

#Preview {
    AccountDeleteFlowView(
        store: Store(initialState: AccountDeleteFlowFeature.State(nickname: "땡땡")) {
            AccountDeleteFlowFeature()
        }
    )
}
