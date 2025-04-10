//
//  ImjangDetailViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 4/9/25.
//

import ReactorKit

final class ImjangDetailViewReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        let title: String
    }
        
    struct Dependency {
        let id: Int
        let title: String
    }
    
    let initialState: State
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.initialState = State(title: dependency.title)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//            
//        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
//        switch mutation {
//        
//        }
        return state
    }
}
