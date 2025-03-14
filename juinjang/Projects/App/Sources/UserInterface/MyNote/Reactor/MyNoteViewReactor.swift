//
//  MyNoteViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 3/11/25.
//

import ReactorKit

final class MyNoteViewReactor: Reactor {
    enum Action {
        case categoryButtonDidTap(Int)
    }

    enum Mutation {
        case setCategoryState(Int)
    }

    struct State {
        var categoryState: MyNoteCategoryState = .share
    }

    let initialState: State = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .categoryButtonDidTap(let index):
            return .just(.setCategoryState(index))
        }
    }

    func reduce(state: State,
                mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setCategoryState(let index):
            state.categoryState = MyNoteCategoryState(rawValue: index) ?? .share
        }
        return state
    }
}

extension MyNoteViewReactor {
    enum MyNoteCategoryState: Int, CaseIterable {
        case share = 0
        case own = 1
        case like = 2
    }
}
