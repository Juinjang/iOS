//
//  MyNoteStopShareViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 3/29/25.
//

import ReactorKit
import RxRelay

final class MyNoteStopShareViewReactor: Reactor {
    // MARK: - Action
    enum Action {
        case viewDidLoad
        case removeButtonDidTap
        case removeConfirmDidTap
        case cellEventOccurred(event: MyNoteCellEventType)
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setList([MyNoteCellModel])
        case setSelectedItem(Int?)
        case updateIsShowStopShareAlertView
        case updateIsShowStopShareCompletedView
    }
    
    // MARK: - State
    struct State {
        var list: [MyNoteCellModel] = []
        var selectedItem: Int?
        var isShowStopShareAlertView: Bool?
        var isShowStopShareCompletedView: Bool?
    }
    
    let initialState = State()
    
    // MARK: - Dependency
    struct Dependency {
        let noteRepository: SharedNoteRepositoryProtocol
        let stopShareNoteRelay: PublishRelay<Int>
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
                        noteType: "SHARED",
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
            return .just(.updateIsShowStopShareAlertView)
        case .cellEventOccurred(event: let event):
            return handleCellEvent(event)
        case .removeConfirmDidTap:
            return stopShareNote()
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setList(let list):
            newState.list = list
        case .setSelectedItem(let item):
            newState.selectedItem = item
        case .updateIsShowStopShareAlertView:
            newState.isShowStopShareAlertView = !(newState.isShowStopShareAlertView ?? false)
        case .updateIsShowStopShareCompletedView:
            newState.isShowStopShareCompletedView = !(newState.isShowStopShareCompletedView ?? false)
        }
        return newState
    }
}

// MARK: - Mutate Methods
extension MyNoteStopShareViewReactor {
    private func stopShareNote() -> Observable<Mutation> {
        guard let noteId = currentState.selectedItem else {
            return .empty()
        }
        
        return dependency
            .noteRepository
            .deleteSharedNote(noteID: noteId)
            .andThen(Observable.deferred { [weak self] in
                guard let self else { return .empty() }
                self.dependency.stopShareNoteRelay.accept(noteId)
                return .just(.updateIsShowStopShareCompletedView)
            })
    }
    
    private func handleCellEvent(_ event: MyNoteCellEventType) -> Observable<Mutation> {
        switch event {
        case .likeButtonTap(_):
            return .empty()
        case .cellTap(let id, _):
            var updatedList = currentState.list
            
            // 전체 isSelected 초기화 (모두 false)
            updatedList = updatedList.map {
                var item = $0
                item.isSelected = false
                return item
            }
            
            // 선택된 아이템만 true로 변경
            if let index = updatedList.firstIndex(where: { $0.sharedNoteId == id }) {
                updatedList[index].isSelected = true
            }
            
            return .concat([
                .just(.setList(updatedList)),
                .just(.setSelectedItem(id))
            ])
        }
    }
}

// MARK: - Reduce Methods
extension MyNoteStopShareViewReactor {
    
}
