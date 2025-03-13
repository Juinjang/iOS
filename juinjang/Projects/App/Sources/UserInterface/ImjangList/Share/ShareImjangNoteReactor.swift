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
        case selectCell(Int?)
        case tapPrevious
        case tapNext
        case tapLoadMore
    }
    
    enum Mutation {
        case setNavigation(Navigation)
        case setItems([ListDto])
        case setSelectedIndex(Int?)
        case setEmptyViewVisible(Bool)
        case setNextButtonEnabled(Bool)
    }
    
    struct State {
        var navigation: Navigation?
        var items: [ListDto] = []
        var selectedIndex: Int?
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
            
        case .selectCell(let index):
            let selectedIndex: Int?
            if currentState.selectedIndex == index {
                selectedIndex = nil
            } else {
                selectedIndex = index
            }
            return Observable.concat(
                .just(.setSelectedIndex(selectedIndex)),
                .just(.setNextButtonEnabled(selectedIndex != nil ? true : false))
            )
        
        // FIXME: 서버 API 연동 후 페이지네이션 로직에 따라 변경
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
        var newState = state
        
        switch mutation {
        case .setNavigation(let navigation):
            newState.navigation = navigation
        
        case .setItems(let items):
            newState.items = items
        
        case .setEmptyViewVisible(let isEmptyViewVisible):
            newState.isEmptyViewVisible = isEmptyViewVisible
        
        case .setNextButtonEnabled(let isEnabledNextButton):
            newState.isEnabledNextButton = isEnabledNextButton
        
        case .setSelectedIndex(let index):
            newState.selectedIndex = index
        }
        
        return newState
    }
}

extension ShareImjangNoteReactor {
    enum Navigation {
        case previous
        case imjangNote
        case next
    }
}
