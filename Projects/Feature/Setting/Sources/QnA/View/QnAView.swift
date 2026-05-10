import ComposableArchitecture
import DesignSystem
import Model
import SwiftUI

public struct QnAView: View {
    let store: StoreOf<QnAFeature>

    public init(store: StoreOf<QnAFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            DSNavigationBar()
                .title("자주 묻는 질문")
                .leftItems([.close])
                .onAction { action in
                    if case .closeButtonTapped = action {
                        store.send(.backButtonTapped)
                    }
                }

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                        .padding(.horizontal, 25)
                        .padding(.top, 36)
                        .padding(.bottom, 20)

                    LazyVStack(spacing: 0) {
                        ForEach(store.items) { item in
                            QnAItemView(
                                item: item,
                                isExpanded: store.expandedIDs.contains(item.id)
                            ) {
                                store.send(
                                    .itemTapped(item.id),
                                    animation: .easeInOut(duration: 0.25)
                                )
                            }
                        }
                    }
                }
            }
        }
        .background(Color.mainWhite)
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            DSText("자주 묻는 질문이란?")
                .style(.h3)
                .textColor(.gray450)

            VStack {
                DSText(
                    "주인장을 이용하며 생길 수 있는 궁금증을 조금이나마 해소해 드리기 위한 자주 묻는 질문 모음입니다.\n직접 문의 기능은 준비 중이니 양해 부탁드립니다."
                )
                .style(.body2)
                .textColor(.gray450)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
            }
            .background(Color.gray100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview("QnA") {
    NavigationStack {
        QnAView(
            store: Store(initialState: QnAFeature.State()) {
                QnAFeature()
            }
        )
    }
}
