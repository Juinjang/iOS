import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - OnboardingView

public struct OnboardingView: View {
    @Bindable var store: StoreOf<OnboardingFeature>

    public init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $store.currentPage) {
                ForEach(Array(OnboardingPage.allCases.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(
                        page: page,
                        isCurrentPage: index == store.currentPage
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            VStack(spacing: 0) {
                pageIndicator
                    .padding(.bottom, 24)

                if store.isLoginButtonVisible {
                    AppButton("로그인 페이지로", style: .gray) {
                        store.send(.loginButtonTapped)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                    .transition(.opacity.animation(.easeIn(duration: 0.5)))
                }
            }
        }
        .background(Color.mainWhite)
    }

    private var pageIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<OnboardingPage.allCases.count, id: \.self) { index in
                Circle()
                    .fill(index == store.currentPage ? Color.main : Color.main100)
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: store.currentPage)
            }
        }
    }
}
