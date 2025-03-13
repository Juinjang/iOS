//
//  ShareImjangNoteReactor.swift
//  juinjang
//
//  Created by 강동영 on 3/7/25.
//

import Foundation
import ReactorKit

final class ShareImjangNoteReactor: Reactor {
    private let repository: ShareImjangNoteRepository
    var disposeBag = DisposeBag()
    init(repository: ShareImjangNoteRepository) {
        self.repository = repository
    }
    
    enum Action {
        case viewDidLoad
        case tapBanner
        case tapNavigateImjangNoteList
        case selectCell(ListDto?)
        case tapPrevious
        case tapNext
        case tapLoadMore
    }
    
    enum Mutation {
        case setNavigation(Navigation)
        case setItems([ListDto])
        case setSelectedItem(ListDto?)
        case setEmptyViewVisible(Bool)
        case setNextButtonEnabled(Bool)
    }
    
    struct State {
        var navigation: Navigation?
        var items: [ListDto] = []
        var selectedItem: ListDto?
        var isEmptyViewVisible: Bool = false
        var isEnabledNextButton: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return repository.fetchNotes()
                .map {
                    [Mutation.setItems($0),
                     Mutation.setEmptyViewVisible(!$0.isEmpty)]
                }
                .catchAndReturn([.setItems([]), .setEmptyViewVisible(true)])
                .flatMap { Observable.from($0) }
            
        case .tapBanner:
            return .empty()
            
        case .tapNavigateImjangNoteList:
            return .just(.setNavigation(.imjangNote))
            
        case .tapPrevious:
            return .just(.setNavigation(.previous))
            
        case .tapNext:
            return .just(.setNavigation(.next))
            
        case .selectCell(let listDto):
            return Observable.concat(
                .just(.setSelectedItem(listDto)),
                .just(.setNextButtonEnabled(listDto != nil ? true : false))
            )
        
        case .tapLoadMore:
            return repository.fetchNotes()
                .map {
                    [Mutation.setItems($0),
                     Mutation.setEmptyViewVisible(!$0.isEmpty)]
                }
                .catchAndReturn([.setItems([]), .setEmptyViewVisible(true)])
                .flatMap { Observable.from($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setNavigation(let navigation):
            state.navigation = navigation
        
        case .setItems(let items):
            state.items = items
        
        case .setEmptyViewVisible(let isEmptyViewVisible):
            state.isEmptyViewVisible = isEmptyViewVisible
        
        case .setNextButtonEnabled(let isEnabledNextButton):
            state.isEnabledNextButton = isEnabledNextButton
        
        case .setSelectedItem(let item):
            state.selectedItem = item
        }
        
        return state
    }
}

extension ShareImjangNoteReactor {
    enum Navigation {
        case previous
        case imjangNote
        case next
    }
}
