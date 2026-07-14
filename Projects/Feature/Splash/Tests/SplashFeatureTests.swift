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

    @Test("userStatus가 false면 온보딩으로 이동한다")
    func navigatesToOnboardingWhenUserStatusIsFalse() async {
        let store = TestStore(
            initialState: SplashFeature.State()
        ) {
            SplashFeature()
        } withDependencies: {
            $0.appVersionClient.latestVersion = { "1.0.0" }
            $0.appVersionClient.currentVersion = { "1.0.0" }
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

    @Test("userStatus가 true이고 accessToken이 없으면 로그인으로 이동한다")
    func navigatesToLoginWhenAccessTokenEmpty() async {
        let store = TestStore(
            initialState: SplashFeature.State()
        ) {
            SplashFeature()
        } withDependencies: {
            $0.appVersionClient.latestVersion = { "1.0.0" }
            $0.appVersionClient.currentVersion = { "1.0.0" }
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

    @Test("userStatus가 true이고 accessToken이 있으면 홈으로 이동한다")
    func navigatesToHomeWhenAccessTokenPresent() async {
        let store = TestStore(
            initialState: SplashFeature.State()
        ) {
            SplashFeature()
        } withDependencies: {
            $0.appVersionClient.latestVersion = { "1.0.0" }
            $0.appVersionClient.currentVersion = { "1.0.0" }
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
