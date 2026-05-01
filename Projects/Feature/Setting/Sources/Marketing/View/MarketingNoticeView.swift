import ComposableArchitecture
import DesignSystem
import Model
import SwiftUI

public struct MarketingNoticeView: View {
    let store: StoreOf<MarketingNoticeFeature>

    public init(store: StoreOf<MarketingNoticeFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            DSNavigationBar()
                .title("마케팅 동의 및 이벤트 수신")
                .leftItems([.pop])
                .onAction { action in
                    if case .popButtonTap = action {
                        store.send(.view(.backButtonTapped))
                    }
                }

            DSText(MarketingConsentContent.notice)
                .style(.body2)
                .textColor(.gray500)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 45)
                .padding(.vertical, 22)

            Divider().background(Color.gray100)

            Button {
                store.send(.view(.termsRowTapped))
            } label: {
                HStack(spacing: 8) {
                    Image.documentText
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                    DSText("이용약관")
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

            Divider().background(Color.gray100)

            Spacer()
        }
        .background(Color.mainWhite)
        .navigationBarHidden(true)
    }
}

#Preview("MarketingNotice") {
    NavigationStack {
        MarketingNoticeView(
            store: Store(initialState: MarketingNoticeFeature.State()) {
                MarketingNoticeFeature()
            }
        )
    }
}
