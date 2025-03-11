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
        case viewDidLoad
        case pageChanged(OnboardingType)
        case updateLoginButtonVisible(Bool)
        case loginButtonTapped
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setCurrentPage(Int)
        case setLoginButtonVisible(Bool)
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
        case .viewDidLoad:
            trackAmplitude(with: .onboarding_start)
            return .empty()
            
        case .pageChanged(let viewType):
            trackAmplitude(with: toMapAmpliEventType(with: viewType))
            return .just(.setCurrentPage(viewType.rawValue))
            
        case .updateLoginButtonVisible(let visible):
            return .just(.setLoginButtonVisible(visible))
            
        case .loginButtonTapped:
            UserDefaultManager.shared.userStatus = true
            trackAmplitude(with: .onboarding_complete)
            return .just(.navigateToLogin)
        }
    }
    
    // Mutation을 State로 변환
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCurrentPage(let index):
            newState.currentPage = index
            
        case .setLoginButtonVisible(let visible):
            newState.isLoginButtonVisible = visible
            
        case .navigateToLogin:
            newState.shouldNavigateToLogin = true
        }
        
        return newState
    }
    
    private func trackAmplitude(with name: AmpliEventName) {
        amplitude.track(eventType: name.rawValue)
    }
    
    private func toMapAmpliEventType(with viewType: OnboardingType) -> AmpliEventName {
        switch viewType {
        case .checklist:
            return .onboarding_step_1
            
        case .recordImjang:
            return .onboarding_step_2
            
        case .report:
            return .onboarding_step_3
        }
    }
}
