//
//  OnboardingContainerReactor.swift
//  juinjang
//
//  Created by 강동영 on 2/24/25.
//

import Foundation
import ReactorKit

final class OnboardingReactor: Reactor {
    // MARK: - Action
    enum Action {
        case pageChanged(OnboardingType)
        case updateLoginButtonVisible(Bool)
        case loginButtonTapped
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setCurrentPage(Int)
        case setLoginButtonVisible(Bool)
        case trackAmplitude(OnboardingType)
        case navigateToLogin
    }
    
    // MARK: - State
    struct State {
        var currentPage: Int = 0
        var isLoginButtonVisible: Bool = false
        var shouldNavigateToLogin: Bool = false
    }
    
    let initialState: State = State()

    // Action을 받아서 Mutation을 반환하는 함수
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .pageChanged(let viewType):
            return Observable.concat(
                .just(.setCurrentPage(viewType.rawValue)),
                .just(.trackAmplitude(viewType))
            )
            
        case .updateLoginButtonVisible(let visible):
            return .just(.setLoginButtonVisible(visible))
            
        case .loginButtonTapped:
            UserDefaultManager.shared.userStatus = true
            amplitude.track(eventType: AmpliEventName.onboarding_complete.rawValue)
            return .just(.navigateToLogin)
        }
    }
    
    // Mutation을 State로 변환
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCurrentPage(let index):
            newState.currentPage = index
            
        case .trackAmplitude(let viewType):
            trackAmplitude(with: viewType)
            
        case .setLoginButtonVisible(let visible):
            newState.isLoginButtonVisible = visible
            
        case .navigateToLogin:
            newState.shouldNavigateToLogin = true
        }
        
        return newState
    }
    
    private func trackAmplitude(with viewType: OnboardingType) {
        switch viewType {
        case .checklist:
            amplitude.track(eventType: AmpliEventName.onboarding_step_1.rawValue)
        
        case .recordImjang:
            amplitude.track(eventType: AmpliEventName.onboarding_step_2.rawValue)
        
        case .report:
            amplitude.track(eventType: AmpliEventName.onboarding_step_3.rawValue)
        }
    }
}
