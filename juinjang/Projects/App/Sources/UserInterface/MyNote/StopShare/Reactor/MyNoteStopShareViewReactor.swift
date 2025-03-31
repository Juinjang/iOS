//
//  MyNoteStopShareViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 3/29/25.
//

import ReactorKit

final class MyNoteStopShareViewReactor: Reactor {
    // MARK: - Action
    enum Action {
        case viewDidLoad
        case removeButtonDidTap
        case cellEventOccurred(event: MyNoteCellEventType)
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setLoading(Bool)
        case setStopped(Bool)
        case setError(String?)
        case setList([MyNoteCellModel])
        case addSelectedItem(MyNoteCellModel)
    }
    
    // MARK: - State
    struct State {
        var isLoading: Bool = false
        var isStopped: Bool = false
        var errorMessage: String? = nil
        var list: [MyNoteCellModel] = []
        var selectedList: [MyNoteCellModel] = []
    }
    
    let initialState = State()
    
    // MARK: - Dependency
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
        case .viewDidLoad:
            return .concat([
                .just(.setLoading(true)),
                dependency.myNoteRepository
                    .fetchMyNotes(category: .share, offset: 0, limit: 100)
                    .map { notes in
                        let models = notes.map { note -> MyNoteCellModel in
                            var model = MyNoteCellModel(model: note)
                            model.isStopShare = true
                            return model
                        }
                        return .setList(models)
                    }
                    .catch { error in
                        return .just(.setError(error.localizedDescription))
                    },
                .just(.setLoading(false))
            ])
        case .removeButtonDidTap:
            return .concat([
                .just(.setLoading(true)),
                .just(.setLoading(false))
            ])
        case .cellEventOccurred(event: let event):
            return handleCellEvent(event)
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLoading(let loading):
            newState.isLoading = loading
        case .setStopped(let isStopped):
            newState.isStopped = isStopped
        case .setError(let message):
            newState.errorMessage = message
        case .setList(let list):
            newState.list = list
        case .addSelectedItem(let item):
            newState.selectedList.append(item)
        }
        return newState
    }
}

// MARK: - Mutate Methods
extension MyNoteStopShareViewReactor {
    private func handleCellEvent(_ event: MyNoteCellEventType) -> Observable<Mutation> {
        switch event {
        case .likeButtonTap(let id):
            return .empty()
        case .cellTap(let id):
            return .empty()
        }
    }
}

// MARK: - Reduce Methods
extension MyNoteStopShareViewReactor {
    
}
