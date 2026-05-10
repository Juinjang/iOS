import ComposableArchitecture
import Foundation
import Model

@Reducer
public struct TermsListFeature: Sendable {
    @Reducer(state: .equatable, .sendable, action: .sendable)
    public enum Path {
        case termsDetail(TermsDetailFeature)
        case marketingNotice(MarketingNoticeFeature)
    }

    @ObservableState
    public struct State: Equatable, Sendable {
        public var documents: [TermsDocument]
        public var path: StackState<Path.State>

        public init(
            documents: [TermsDocument] = TermsDocument.allCases,
            path: StackState<Path.State> = StackState()
        ) {
            self.documents = documents
            self.path = path
        }
    }

    public enum Action: Sendable {
        case backButtonTapped
        case documentTapped(TermsDocument)
        case path(StackActionOf<Path>)
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { _ in await dismiss() }

            case let .documentTapped(doc):
                if doc == .marketingConsent {
                    state.path.append(.marketingNotice(MarketingNoticeFeature.State()))
                } else {
                    state.path.append(.termsDetail(TermsDetailFeature.State(document: doc)))
                }
                return .none

            case .path(.element(_, .marketingNotice(.delegate(.openTermsDetail)))):
                state.path.append(.termsDetail(TermsDetailFeature.State(document: .marketingConsent)))
                return .none

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
