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
                .leftItems([.pop])
                .onAction { action in
                    if case .popButtonTap = action {
                        store.send(.view(.backButtonTapped))
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
                                    .view(.itemTapped(item.id)),
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

// MARK: - QnA item (펼침/접힘 셀)

struct QnAItemView: View {
    let item: QnAItem
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onTap) {
                HStack(spacing: 8) {
                    Image.qna
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.main200)

                    Text(highlightedQuestion)
                        .font(DSFontStyle.title.font)
                        .foregroundStyle(Color.gray500)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundStyle(Color.gray200)
                }
                .contentShape(Rectangle())
                .padding(.horizontal, 22)
                .padding(.vertical, 24)
                .sectionDivider(.bottom)
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack {
                    DSText(item.answer)
                        .style(.body2)
                        .textColor(.gray500)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 16)
                }
                .frame(maxWidth: .infinity)
                .background(Color.gray100)
                .transition(
                    .asymmetric(
                        insertion: .opacity.animation(
                            .easeOut(duration: 0.35).delay(0.1)
                        ),
                        removal: .opacity.animation(
                            .easeIn(duration: 0.1)
                        )
                    )
                )
            }
        }
    }

    private var highlightedQuestion: AttributedString {
        var attributed = AttributedString(item.question)
        if let range = attributed.range(of: item.highlight) {
            attributed[range].foregroundColor = .main
        }
        return attributed
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
