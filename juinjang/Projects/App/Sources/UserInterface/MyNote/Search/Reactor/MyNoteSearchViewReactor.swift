//
//  MyNoteSearchViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 3/29/25.
//

import ReactorKit

final class MyNoteSearchViewReactor: Reactor {
    // MARK: - Action
    enum Action {
        case searchSummitButtonTapped(keyword: String)
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setList([MyNoteCellModel])
        case setLoading(Bool)
    }
    
    // MARK: - State
    struct State {
        var list: [MyNoteCellModel] = []
        var isLoading: Bool = false
        var isFirstFetch: Bool = false
        var isEmpty: Bool {
            return !isLoading && list.isEmpty && isFirstFetch
        }
    }
    
    let initialState = State()
    
    // MARK: - Dependencies
    struct Dependency {
        let myNoteRepository: MyNoteRepositoryProtocol
    }
    
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchSummitButtonTapped(let keyword):
            return .concat([
                .just(.setLoading(true)),
                dependency.myNoteRepository
                    .fetchMyNotes(keyword: keyword)
                    .map { notes in
                        return .setList(notes.map { MyNoteCellModel(model: $0) })
                    },
                
                .just(.setLoading(false))
            ])
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setList(let list):
            newState.isFirstFetch = true
            newState.list = list
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}
