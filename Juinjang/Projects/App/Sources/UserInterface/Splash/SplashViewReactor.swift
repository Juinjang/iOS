//
//  SplashViewReactor.swift
//  juinjang
//
//  Created by 강동영 on 2/17/25.
//

import ReactorKit
import Foundation

final class SplashViewReactor: Reactor {
    enum Action {
        case viewDidLoad
        case openAppStore
    }
    
    enum Mutation {
        case setNavigation(SplashNavigation)
        case setShowUpdateAppPopup(Bool)
    }
    
    struct State {
        var navigation: SplashNavigation?
        var showUpdateAppPopup: Bool = false
    }
    
    let initialState: State = State()
    
    struct Dependency {
        let appVersionRepository: AppVersionRepositoryProtocol
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return checkAppVersion()
        case .openAppStore:
            return openAppStore()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setNavigation(let splashNavigation):
            state.navigation = splashNavigation
        case .setShowUpdateAppPopup(let show):
            state.showUpdateAppPopup = show
        }
        return state
    }
    
    private func checkAppVersion() -> Observable<Mutation> {
        // 앱 스토어 앱 버전 조회
        return InAppUpdateManager.shared.requestLatestVersion()
            .asObservable()
            .flatMap { [weak self] appVersion -> Observable<Mutation> in
                guard let self = self, let latestVersion = appVersion else { return .empty() }
                print("@@@ Latest AppVersion: \(latestVersion)")
                return self.handleAppUpdate(latestVersion: latestVersion)
            }
    }

    private func handleAppUpdate(latestVersion: String) -> Observable<Mutation> {
        if InAppUpdateManager.shared.isNeedAppUpdate(latestVersion: latestVersion) {
            return .just(.setShowUpdateAppPopup(true))
        } else {
            return FirebaseStoreManager.shared.fetchMaintenanceAsObservable()
                .flatMap { [weak self] maintenance -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    if maintenance.needsMaintenance {
                        return .just(.setNavigation(.maintenanceNotice))
                    } else {
                        return self.setNavigation()
                    }
                }
        }
    }
    
    private func setNavigation() -> Observable<Mutation> {
        let navigation: SplashNavigation
        if !UserDefaultManager.shared.userStatus {  // false 일 때 (앱 최초 실행 시)
            // 온보딩 화면으로 이동
            navigation = .onbording
        } else if UserDefaultManager.shared.accessToken.isEmpty {
            // accessToken 없을 경우 로그인 화면으로 이동
            navigation = .login
        } else {
            // 기존에 로그인이 되어 있는 경우 isOnboarding = false
            UserDefaultManager.shared.isOnboarding = false
            navigation = .home
        }
        return .just(.setNavigation(navigation))
    }
    
    // 앱 스토어로 이동
    private func openAppStore() -> Observable<Mutation> {
        InAppUpdateManager.shared.openAppStore()
        return .empty()
    }
}

extension SplashViewReactor {
    enum SplashNavigation {
        case onbording
        case login
        case home
        case maintenanceNotice
    }
}
