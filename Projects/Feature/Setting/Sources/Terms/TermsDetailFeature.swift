import ComposableArchitecture
import Foundation
import Model

@Reducer
public struct TermsDetailFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public let document: TermsDocument

        public init(document: TermsDocument) {
            self.document = document
        }
    }

    public enum Action {
        case view(View)

        @CasePathable
        public enum View: Equatable {
            case backButtonTapped
        }
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.backButtonTapped):
                return .run { _ in await dismiss() }
            }
        }
    }
}
