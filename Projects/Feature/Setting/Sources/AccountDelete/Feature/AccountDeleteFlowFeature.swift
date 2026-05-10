import ComposableArchitecture
import Foundation
import Model

@Reducer
public struct AccountDeleteFlowFeature: Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        public var nickname: String
        public var isShowingReason: Bool
        public var selectedReasons: Set<AccountDeleteReason>

        public init(
            nickname: String = "",
            isShowingReason: Bool = false,
            selectedReasons: Set<AccountDeleteReason> = []
        ) {
            self.nickname = nickname
            self.isShowingReason = isShowingReason
            self.selectedReasons = selectedReasons
        }
    }

    public enum Action: Equatable, Sendable {
        case isShowingReasonChanged(Bool)
        case reasonToggled(AccountDeleteReason)
        case cancelTapped
        case finalDeleteTapped
    }

    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .isShowingReasonChanged(value):
                state.isShowingReason = value
                return .none

            case let .reasonToggled(reason):
                if state.selectedReasons.contains(reason) {
                    state.selectedReasons.remove(reason)
                } else {
                    state.selectedReasons.insert(reason)
                }
                return .none

            case .cancelTapped:
                return .run { _ in await dismiss() }

            case .finalDeleteTapped:
                print("[AccountDeleteFlow] mock final delete, reasons: \(state.selectedReasons.map(\.rawValue))")
                return .run { _ in await dismiss() }
            }
        }
    }
}
