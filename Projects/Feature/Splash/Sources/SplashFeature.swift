import Common
import ComposableArchitecture
import Dependency
import UIKit

@Reducer
public struct SplashFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        public var showUpdatePopup: Bool = false

        public init(showUpdatePopup: Bool = false) {
            self.showUpdatePopup = showUpdatePopup
        }
    }

    public enum Action {
        case view(View)
        case animationCompleted
        case versionCheckCompleted(needsUpdate: Bool)
        case updateButtonTapped
        case delegate(Delegate)

        public enum View: Equatable {
            case onAppear
        }

        public enum Delegate: Equatable {
            case navigateTo(Route)
        }
        
        public enum Route {
            case onboarding
            case login
            case home
        }
    }

    @Dependency(\.appVersionClient) var appVersionClient
    @Dependency(\.userDefaultsClient) var userDefaultsClient

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .animationCompleted:
                return .run { send in
                    do {
                        let needsUpdate = try await appVersionClient.checkNeedsUpdate()
                        print("🔍 Version check result: needsUpdate = \(needsUpdate)")
                        await send(.versionCheckCompleted(needsUpdate: needsUpdate))
                    } catch {
                        print("🔍 Version check error: \(error)")
                        await send(.versionCheckCompleted(needsUpdate: false))
                    }
                }

            case .versionCheckCompleted(needsUpdate: true):
                state.showUpdatePopup = true
                return .none

            case .versionCheckCompleted(needsUpdate: false):
                return .run { send in
                    let userStatus = userDefaultsClient.bool(.userStatus, default: false)
                    let accessToken = (try? userDefaultsClient.string(.accessToken)) ?? ""

                    if !userStatus {
                        await send(.delegate(.navigateTo(.onboarding)))
                    } else if accessToken.isEmpty {
                        await send(.delegate(.navigateTo(.login)))
                    } else {
                        await send(.delegate(.navigateTo(.home)))
                    }
                }

            case .updateButtonTapped:
                return .run { _ in
                    await MainActor.run {
                        UIApplication.shared.open(AppInfo.appStoreURL)
                    }
                }

            case .delegate:
                return .none
            }
        }
    }
}
