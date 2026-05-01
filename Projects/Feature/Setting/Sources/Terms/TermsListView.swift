import ComposableArchitecture
import DesignSystem
import Model
import SwiftUI

public struct TermsListView: View {
    let store: StoreOf<TermsListFeature>

    public init(store: StoreOf<TermsListFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            DSNavigationBar()
                .title("이용 및 약관")
                .leftItems([.pop])
                .onAction { action in
                    if case .popButtonTap = action {
                        store.send(.view(.backButtonTapped))
                    }
                }

            VStack(spacing: 0) {
                ForEach(store.documents, id: \.self) { document in
                    TermsDocumentRow(document: document) {
                        store.send(.view(.documentTapped(document)))
                    }

                    if document != store.documents.last {
                        Divider().background(Color.gray100)
                    }
                }
            }
            .padding(.top, 3)

            Spacer()
        }
        .background(Color.mainWhite)
        .navigationBarHidden(true)
    }
}

#Preview("TermsList") {
    NavigationStack {
        TermsListView(
            store: Store(initialState: TermsListFeature.State()) {
                TermsListFeature()
            }
        )
    }
}
