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
        case tapExpandNewPage
        case selectCell(ListDto)
        case tapNext
        case tapLoadMore
    }
    
    enum Mutation {
        case setNavigation(Navigation)
        case setItems([ListDto])
        case setSelectedItem(ListDto?)
        case setEmptyViewVisible(Bool)
        case setLoadMoreEnabled(Bool)
    }
    
    struct State {
        var navigation: Navigation?
        var items: [ListDto] = []
        var selectedItem: ListDto?
        var isEmptyViewVisible: Bool = false
        var isLoadMoreEnabled: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return Observable.concat([
                repository.fetchNotes()
                    .map { .setItems($0) }
                    .catchAndReturn(.setItems([])),
                .just(.setEmptyViewVisible(currentState.items.isEmpty))
            ])
        case .tapBanner:
            let navigation: Navigation
            navigation = .checkList
            return .just(.setNavigation(navigation))
            
        case .tapExpandNewPage:
            let navigation: Navigation
            navigation = .checkList
            return .just(.setNavigation(navigation))
        
        case .tapNext:
            let navigation: Navigation
            navigation = .next
            return .just(.setNavigation(navigation))
            
        case .selectCell(let listDto):
            return .just(.setSelectedItem(listDto))
        
        case .tapLoadMore:
            return Observable.concat([
                repository.fetchNotes(offset: currentState.items.count)
                    .map { .setItems($0) }
                    .catchAndReturn(.setItems([])),
                .just(.setEmptyViewVisible(currentState.items.isEmpty))
            ])
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
        
        case .setLoadMoreEnabled(let isLoadMoreEnabled):
            state.isLoadMoreEnabled = isLoadMoreEnabled
        
        case .setSelectedItem(let item):
            state.selectedItem = item
        }
        
        return state
    }
}

extension ShareImjangNoteReactor {
    enum Navigation {
        case previous
        case checkList
        case next
    }
}
