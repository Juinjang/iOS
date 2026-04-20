import Foundation
import Testing

import Common
import Dependency
@testable import Splash
@testable import SplashTesting

import ComposableArchitecture

@MainActor
struct SplashFeatureTests {

    @Test
    func onAppear() async {
        let store = TestStore(
            initialState: SplashFeature.State()
        ) {
            SplashFeature()
        }

        await store.send(.onAppear)
    }

    // MARK: - animationCompleted

    @Test
    func animationCompleted_navigatesToOnboarding_whenUserStatusIsFalse() async {
        let store = TestStore(
            initialState: SplashFeature.State()
        ) {
            SplashFeature()
        } withDependencies: {
            $0.userDefaultsClient.hasValue = { _ in false }
            $0.userDefaultsClient.get = { key in
                switch key {
                case .userStatus:
                    throw UserDefaultsError.keyNotFound(key: key)
                default:
                    throw UserDefaultsError.keyNotFound(key: key)
                }
            }
        }

        await store.send(.animationCompleted)
        await store.receive(\.versionCheckCompleted)
        await store.receive(\.delegate.navigateTo)
    }

    @Test
    func animationCompleted_navigatesToLogin_whenUserStatusTrueAndAccessTokenEmpty() async {
        let store = TestStore(
            initialState: SplashFeature.State()
        ) {
            SplashFeature()
        } withDependencies: {
            $0.userDefaultsClient.get = { key in
                switch key {
                case .userStatus:
                    return try JSONEncoder().encode(true)
                case .accessToken:
                    throw UserDefaultsError.keyNotFound(key: key)
                default:
                    throw UserDefaultsError.keyNotFound(key: key)
                }
            }
        }

        await store.send(.animationCompleted)
        await store.receive(\.versionCheckCompleted)
        await store.receive(\.delegate.navigateTo)
    }

    @Test
    func animationCompleted_navigatesToHome_whenUserStatusTrueAndAccessTokenPresent() async {
        let store = TestStore(
            initialState: SplashFeature.State()
        ) {
            SplashFeature()
        } withDependencies: {
            $0.userDefaultsClient.get = { key in
                switch key {
                case .userStatus:
                    return try JSONEncoder().encode(true)
                case .accessToken:
                    return try JSONEncoder().encode("token123")
                default:
                    throw UserDefaultsError.keyNotFound(key: key)
                }
            }
        }

        await store.send(.animationCompleted)
        await store.receive(\.versionCheckCompleted)
        await store.receive(\.delegate.navigateTo)
    }
}
