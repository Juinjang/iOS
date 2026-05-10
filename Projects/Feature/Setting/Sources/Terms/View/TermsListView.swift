import ComposableArchitecture
import DesignSystem
import Model
import SwiftUI

public struct TermsListView: View {
    @Bindable var store: StoreOf<TermsListFeature>

    public init(store: StoreOf<TermsListFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            mainContent
        } destination: { store in
            switch store.case {
            case let .termsDetail(store):
                TermsDetailView(store: store)
            case let .marketingNotice(store):
                MarketingNoticeView(store: store)
            }
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        VStack(spacing: 0) {
            DSNavigationBar()
                .title("이용 및 약관")
                .leftItems([.close])
                .onAction { action in
                    if case .closeButtonTapped = action {
                        store.send(.backButtonTapped)
                    }
                }

            VStack(spacing: 0) {
                ForEach(store.documents, id: \.self) { document in
                    TermsDocumentRowView(document: document) {
                        store.send(.documentTapped(document))
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
    TermsListView(
        store: Store(initialState: TermsListFeature.State()) {
            TermsListFeature()
        }
    )
}
