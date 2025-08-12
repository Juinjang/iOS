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
            return fetchIOSSetting()
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
        return dependency.appVersionRepository.retrieveLatestAppVersion()
            .asObservable()
            .flatMap { [weak self] latestAppVersionDTO -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                let version = latestAppVersionDTO.version
                return handleAppUpdate(latestVersion: version)
            }
    }
    
    private func handleAppUpdate(latestVersion: String) -> Observable<Mutation> {
        if InAppUpdateManager.shared.isNeedAppUpdate(latestVersion: latestVersion) {
            return .just(.setShowUpdateAppPopup(true))
        } else {
            return setNavigation()
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
            // 홈 화면으로 이동
            navigation = .home
        }
        return .just(.setNavigation(navigation))
    }
    
    private func fetchIOSSetting() -> Observable<Mutation> {
        return FirebaseStoreManager.shared.fetchIOSSettingAsObservable()
            .flatMap { [weak self] setting -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                UserDefaultManager.shared.isTesting = setting.isTesting
                UserDefaultManager.shared.isHttpsEnabled = setting.isHttpsEnabled
                
                if BuildConfig.isDebug {
                    return setNavigation()
                } else {
                    return checkAppVersion()
                }
            }
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
    }
}
