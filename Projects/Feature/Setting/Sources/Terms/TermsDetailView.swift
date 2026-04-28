import ComposableArchitecture
import DesignSystem
import Model
import SwiftUI

public struct TermsDetailView: View {
    let store: StoreOf<TermsDetailFeature>

    public init(store: StoreOf<TermsDetailFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            DSNavigationBar()
                .title(store.document.title)
                .leftItems([.pop])
                .onAction { action in
                    if case .popButtonTap = action {
                        store.send(.view(.backButtonTapped))
                    }
                }

            ScrollView(showsIndicators: true) {
                Text(attributedBody)
                    .font(DSFontStyle.body2.font)
                    .foregroundStyle(Color.gray500)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
            }
            .background(Color.gray100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.stroke, lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(Color.mainWhite)
        .navigationBarHidden(true)
    }

    private var attributedBody: AttributedString {
        let raw = store.document.body
        return (try? AttributedString(
            markdown: raw,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )) ?? AttributedString(raw)
    }
}

#Preview("이용약관") {
    NavigationStack {
        TermsDetailView(
            store: Store(initialState: TermsDetailFeature.State(document: .termsOfService)) {
                TermsDetailFeature()
            }
        )
    }
}

#Preview("개인정보 처리방침") {
    NavigationStack {
        TermsDetailView(
            store: Store(initialState: TermsDetailFeature.State(document: .privacyPolicy)) {
                TermsDetailFeature()
            }
        )
    }
}

#Preview("마케팅 동의") {
    NavigationStack {
        TermsDetailView(
            store: Store(initialState: TermsDetailFeature.State(document: .marketingConsent)) {
                TermsDetailFeature()
            }
        )
    }
}
