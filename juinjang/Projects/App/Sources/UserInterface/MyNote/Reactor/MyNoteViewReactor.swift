//
//  MyNoteViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 3/11/25.
//

import ReactorKit

final class MyNoteViewReactor: Reactor {
    enum Action {
        case categoryButtonDidTap(MyNoteCategoryState)
        case searchButtonDidTap
    }

    enum Mutation {
        case setNavigation(MyNoteNavigation)
        case setCategoryState(MyNoteCategoryState)
    }

    struct State {
        var navigation: MyNoteNavigation?
        var categoryState: MyNoteCategoryState = .share
    }

    let initialState: State = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .categoryButtonDidTap(let state):
            return .just(.setCategoryState(state))

        case .searchButtonDidTap:
            return .just(.setNavigation(.search))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setNavigation(let newState):
            state.navigation = newState

        case .setCategoryState(let newState):
            state.categoryState = newState
        }
        return state
    }
}


extension MyNoteViewReactor {
    enum MyNoteNavigation {
        case search
    }
    
    enum MyNoteCategoryState {
        case share
        case own
        case like
    }
}
