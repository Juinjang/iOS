//
//  ShareWriteViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 5/3/25.
//

import ReactorKit
import RxSwift

final class ShareWriteViewReactor: Reactor {
    // MARK: - Action
    enum Action {
        case viewDidLoad
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setInitialData
    }
    
    // MARK: - State
    struct State {
        var isInitialized: Bool = false
    }
    
    struct Dependency {
        
    }
    
    // 초기 상태
    let initialState: State = .init()
    private let dependency: Dependency
    
    init(dependecy: Dependency) {
        self.dependency = dependecy
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.setInitialData)
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setInitialData:
            newState.isInitialized = true
        }
        
        return newState
    }
}
