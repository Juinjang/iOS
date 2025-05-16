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
        case setList([MyNoteCellModel])
        case setSelectedList([Int])
        case addSelectedItem(Int)
    }
    
    // MARK: - State
    struct State {
        var list: [MyNoteCellModel] = []
        var selectedList: [Int] = []
    }
    
    let initialState = State()
    
    // MARK: - Dependency
    struct Dependency {
        let noteRepository: NoteRepositoryProtocol
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
                dependency.noteRepository
                    .retrieveMyNotes(param: .init(
                        noteType: "",
                        propertyType: "",
                        priceType: "",
                        keyword: ""
                    ))
                    .asObservable()
                    .map { notes in
                        let models = notes.map { note -> MyNoteCellModel in
                            var model = MyNoteCellModel(model: note)
                            model.isStopShare = true
                            return model
                        }
                        return .setList(models)
                    }
            ])
        case .removeButtonDidTap:
            return .empty()
        case .cellEventOccurred(event: let event):
            return handleCellEvent(event)
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setList(let list):
            newState.list = list
        case .addSelectedItem(let item):
            newState.selectedList.append(item)
        case .setSelectedList(let list):
            newState.selectedList = list
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
            var updatedList = currentState.list
            
            guard let index = updatedList.firstIndex(where: { $0.sharedNoteId == id }) else {
                return .empty()
            }
            
            // 현재 셀 모델
            var item = updatedList[index]
            
            // 토글
            item.isSelected.toggle()
            updatedList[index] = item
            
            // selectedList 업데이트
            var updatedSelectedList = currentState.selectedList
            
            if item.isSelected {
                if !updatedSelectedList.contains(where: { $0 == id }) {
                    updatedSelectedList.append(item.sharedNoteId)
                }
            } else {
                updatedSelectedList.removeAll(where: { $0 == id })
            }
            
            return .concat([
                .just(.setList(updatedList)),
                .just(.setSelectedList(updatedSelectedList))
            ])
        }
    }
}

// MARK: - Reduce Methods
extension MyNoteStopShareViewReactor {
    
}
