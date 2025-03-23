//
//  MyNoteViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 3/11/25.
//

import ReactorKit

final class MyNoteViewReactor: Reactor {
    enum Action {
        case viewDidLoad
        case categoryButtonDidTap(Int)
        case pageCellEventOccurred(event: MyNotePageEventType)
    }

    enum Mutation {
        case setCategoryState(Int)
        case setPage(MyNotePageModel)
        case appendNotes(category: MyNoteCategoryType, notes: [MyNoteModel])
    }

    struct State {
        var categoryState: MyNoteCategoryType = .share
        var sharePageState = NotesPageState()
        var ownPageState = NotesPageState()
        var likePageState = NotesPageState()
        var pages: [MyNotePageModel] = [
            MyNotePageModel(category: .share, items: []),
            MyNotePageModel(category: .own, items: []),
            MyNotePageModel(category: .like, items: [])
        ]
    }
    
    struct Dependency {
        let myNoteRepository: MyNoteRepositoryProtocol
    }
    
    struct NotesPageState {
        var notes: [MyNoteModel] = []
        var offset: Int = 0
        var limit: Int = 20
        var isLastPage: Bool = false
    }

    let initialState: State = State()
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchNotes(for: currentState.categoryState)
        case .categoryButtonDidTap(let index):
            let category = MyNoteCategoryType(rawValue: index) ?? .share
            
            return .concat([
                .just(.setCategoryState(index)),
                fetchNotes(for: category)
            ])
        case .pageCellEventOccurred(event: let event):
            return handlePageCellEvent(event)
        }
    }

    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCategoryState(let index):
            state.categoryState = MyNoteCategoryType(rawValue: index) ?? .share
            
        case .setPage(let page):
            state.pages = state.pages.map {
                guard $0.category != page.category else {
                    return page
                }
                return $0
            }
            
        case let .appendNotes(category, notes):
            switch category {
            case .share:
                state.sharePageState.notes.append(contentsOf: notes)
            case .own:
                state.ownPageState.notes.append(contentsOf: notes)
            case .like:
                state.likePageState.notes.append(contentsOf: notes)
            }
        }
        
        return state
    }
    
    // MARK: - Fetch Notes
    private func fetchNotes(for category: MyNoteCategoryType) -> Observable<Mutation> {
        let pageState = getPageState(for: category)
        let offset = 0
        
        return dependency.myNoteRepository.fetchMyNotes(
            category: category,
            offset: offset,
            limit: pageState.limit
        ).map { notes in
            return Mutation.setPage(.init(category: category, items: notes))
        }
    }
    
    private func fetchMoreNotes(for category: MyNoteCategoryType) -> Observable<Mutation> {
        var pageState = getPageState(for: category)
        guard !pageState.isLastPage else { return .empty() }
        
        return dependency.myNoteRepository.fetchMyNotes(
            category: category,
            offset: pageState.offset + pageState.limit,
            limit: pageState.limit
        ).map { notes in
            let isLastPage = notes.count < pageState.limit
            pageState.offset += notes.count
            pageState.isLastPage = isLastPage
            
            return Mutation.appendNotes(category: category, notes: notes)
        }
    }
    
    private func getPageState(for category: MyNoteCategoryType) -> NotesPageState {
        switch category {
        case .share:
            return currentState.sharePageState
        case .own:
            return currentState.ownPageState
        case .like:
            return currentState.likePageState
        }
    }
    
    private func handlePageCellEvent(_ event: MyNotePageEventType) -> Observable<Mutation> {
        switch event {
        case let .likeButtonTap(category):
            return .empty()
            
        case let .myNoteCellTap(note):
            return .empty()
            
        case let .filterItemTap(category):
            return .empty()
            
        case let .reachBottom(category):
            return .empty()
        }
    }
}
