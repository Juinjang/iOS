//
//  SplashViewReactor.swift
//  juinjang
//
//  Created by 강동영 on 2/17/25.
//

import ReactorKit

final class SplashViewReactor: Reactor {
    enum Action {
        case checkLoginStatus
    }
    
    enum Mutation {
        case setNavigation(SplashNavigation)
    }
    
    struct State {
        var navigation: SplashNavigation?
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkLoginStatus:
            let navigation: SplashNavigation
            if !UserDefaultManager.shared.userStatus {  // false 일 때 (앱 최초 실행 시)
                // 온보딩 화면으로 이동
                navigation = .onbording
            } else if UserDefaultManager.shared.accessToken.isEmpty {
                // accessToken 없을 경우 로그인 화면으로 이동
                navigation = .login
            } else {
                // 홈 화면으로 이동
                navigation = .home
            }
            return .just(.setNavigation(navigation)).debug()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setNavigation(let splashNavigation):
            state.navigation = splashNavigation
            return state
        }
    }
    
}

extension SplashViewReactor {
    enum SplashNavigation {
        case onbording
        case login
        case home
    }
}
