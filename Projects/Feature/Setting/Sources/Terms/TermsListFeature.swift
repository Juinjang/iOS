import ComposableArchitecture
import Foundation
import Model

@Reducer
public struct TermsListFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public var documents: [TermsDocument]

        public init(documents: [TermsDocument] = TermsDocument.allCases) {
            self.documents = documents
        }
    }

    public enum Action {
        case view(View)
        case delegate(Delegate)

        @CasePathable
        public enum View: Equatable {
            case backButtonTapped
            case documentTapped(TermsDocument)
        }

        public enum Delegate: Equatable {
            case documentSelected(TermsDocument)
        }
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.backButtonTapped):
                return .run { _ in await dismiss() }

            case let .view(.documentTapped(doc)):
                return .send(.delegate(.documentSelected(doc)))

            case .delegate:
                return .none
            }
        }
    }
}
