import Foundation
import Testing

import Common
import Dependency
@testable import Onboarding
@testable import OnboardingTesting

import ComposableArchitecture

@MainActor
struct OnboardingFeatureTests {

    // MARK: - currentPage

    @Test("마지막 페이지에 도달하면 로그인 버튼이 노출된다")
    func showsLoginButtonOnLastPage() async {
        let store = TestStore(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }

        let lastPage = OnboardingPage.allCases.count - 1
        await store.send(.binding(.set(\.currentPage, lastPage))) {
            $0.currentPage = lastPage
            $0.isLoginButtonVisible = true
        }
    }

    @Test("마지막 페이지가 아니면 로그인 버튼이 노출되지 않는다")
    func keepsLoginButtonHiddenOnNonLastPage() async {
        let store = TestStore(
            initialState: OnboardingFeature.State()
        ) {
            OnboardingFeature()
        }

        await store.send(.binding(.set(\.currentPage, 1))) {
            $0.currentPage = 1
        }
    }

    @Test("마지막 페이지에서 뒤로 돌아가도 로그인 버튼은 계속 노출된다")
    func keepsLoginButtonVisibleWhenMovingBack() async {
        var initialState = OnboardingFeature.State()
        initialState.currentPage = OnboardingPage.allCases.count - 1
        initialState.isLoginButtonVisible = true

        let store = TestStore(initialState: initialState) {
            OnboardingFeature()
        }

        await store.send(.binding(.set(\.currentPage, 0))) {
            $0.currentPage = 0
        }
    }

    // MARK: - loginButtonTapped

    @Test("로그인 버튼을 누르면 userStatus를 저장하고 로그인 화면으로 이동한다")
    func savesUserStatusAndNavigatesToLoginOnButtonTap() async {
        await confirmation("userStatus true 저장됨") { saved in
            let store = TestStore(
                initialState: OnboardingFeature.State()
            ) {
                OnboardingFeature()
            } withDependencies: {
                $0.userDefaultsClient.set = { data, key in
                    #expect(key == .userStatus)
                    #expect((try? JSONDecoder().decode(Bool.self, from: data)) == true)
                    saved()
                }
            }

            await store.send(.loginButtonTapped)
            await store.receive(\.delegate.navigateToLogin)
        }
    }
}
