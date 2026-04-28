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
                .leftItems([.close])
                .onAction { action in
                    if case .closeButtonTap = action {
                        store.send(.view(.backButtonTapped))
                    }
                }

            VStack(spacing: 0) {
                ForEach(store.documents, id: \.self) { document in
                    documentRow(document)

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

    private func documentRow(_ document: TermsDocument) -> some View {
        Button {
            store.send(.view(.documentTapped(document)))
        } label: {
            HStack(spacing: 8) {
                Image.documentText
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                DSText(document.title)
                    .style(.title)
                    .textColor(.gray500)

                Spacer()

                Image.arrowRight
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .contentShape(Rectangle())
            .padding(.horizontal, 24)
            .frame(height: 64)
        }
        .buttonStyle(.plain)
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
