import ComposableArchitecture
import Foundation
import Model

@Reducer
public struct TermsDetailFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public let document: TermsDocument
        public var selectedVersionID: String
        public var isVersionSelectorExpanded: Bool

        public init(document: TermsDocument) {
            self.document = document
            self.selectedVersionID = document.latestVersion.id
            self.isVersionSelectorExpanded = false
        }

        // MARK: - Derived

        public var versions: [TermsVersion] { document.versions }

        public var selectedVersion: TermsVersion {
            versions.first(where: { $0.id == selectedVersionID }) ?? document.latestVersion
        }

        /// 버전이 1개뿐이면 셀렉터 자체를 숨김 (이용약관 같은 케이스).
        public var showsVersionSelector: Bool { versions.count > 1 }
    }

    public enum Action: Equatable {
        case view(View)

        @CasePathable
        public enum View: Equatable {
            case backButtonTapped
            case versionSelectorExpandedChanged(Bool)
            case versionPicked(String)
        }
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.backButtonTapped):
                return .run { _ in await dismiss() }

            case let .view(.versionSelectorExpandedChanged(value)):
                state.isVersionSelectorExpanded = value
                return .none

            case let .view(.versionPicked(id)):
                state.selectedVersionID = id
                state.isVersionSelectorExpanded = false
                return .none
            }
        }
    }
}
