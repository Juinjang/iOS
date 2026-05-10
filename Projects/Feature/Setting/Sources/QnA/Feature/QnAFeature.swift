import ComposableArchitecture
import Foundation
import Model

@Reducer
public struct QnAFeature: Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        public var items: [QnAItem]
        /// 펼쳐진 항목들의 id 집합
        public var expandedIDs: Set<UUID>

        public init(
            items: [QnAItem] = QnAItem.samples,
            expandedIDs: Set<UUID> = []
        ) {
            self.items = items
            self.expandedIDs = expandedIDs
        }

        public func isExpanded(_ id: UUID) -> Bool {
            expandedIDs.contains(id)
        }
    }

    public enum Action: Sendable {
        case backButtonTapped
        case itemTapped(QnAItem.ID)
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { _ in await dismiss() }

            case let .itemTapped(id):
                if state.expandedIDs.contains(id) {
                    state.expandedIDs.remove(id)
                } else {
                    state.expandedIDs.insert(id)
                }
                return .none
            }
        }
    }
}
