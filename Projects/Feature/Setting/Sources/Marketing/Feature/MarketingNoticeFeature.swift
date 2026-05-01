import ComposableArchitecture
import Foundation
import Model

// MARK: - MarketingNoticeFeature
/// 마케팅 동의 및 이벤트 수신 — 안내 페이지 (develop의 Use3ViewController)
/// 안내문 표시 + "이용약관" 행 탭 시 marketingConsent 본문으로 이동.

@Reducer
public struct MarketingNoticeFeature: Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        public init() {}
    }

    public enum Action: Sendable {
        case view(View)
        case delegate(Delegate)

        @CasePathable
        public enum View: Equatable, Sendable {
            case backButtonTapped
            case termsRowTapped
        }

        public enum Delegate: Equatable, Sendable {
            case openTermsDetail
        }
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.backButtonTapped):
                return .run { _ in await dismiss() }

            case .view(.termsRowTapped):
                return .send(.delegate(.openTermsDetail))

            case .delegate:
                return .none
            }
        }
    }
}
