//
//  MyNoteViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 3/11/25.
//

import ReactorKit

struct MyNotePageModel {
    let category: MyNoteCategoryType
    let sections: [MyNoteSectionModel]
}

final class MyNoteViewReactor: Reactor {
    enum Action {
        case viewDidLoad
        case categoryButtonDidTap(Int)
        case loadMore(category: MyNoteCategoryType)
    }

    enum Mutation {
        case setCategoryState(Int)
        case setSections(category: MyNoteCategoryType, sections: [MyNoteSectionModel])
        case appendNotes(category: MyNoteCategoryType, notes: [MyNoteModel])
    }

    struct State {
        var categoryState: MyNoteCategoryType = .share
        var sharePageState = NotesPageState()
        var ownPageState = NotesPageState()
        var likePageState = NotesPageState()
        var pages: [MyNotePageModel] = [
            MyNotePageModel(category: .share, sections: []),
            MyNotePageModel(category: .own, sections: []),
            MyNotePageModel(category: .like, sections: [])
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
        case .loadMore(let category):
            return fetchMoreNotes(for: category)
        }
    }

    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCategoryState(let index):
            state.categoryState = MyNoteCategoryType(rawValue: index) ?? .share
            
        case let .setSections(category, sections):
            state.pages = state.pages.map {
                guard $0.category != category else {
                    return MyNotePageModel(category: category, sections: sections)
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
            let sections = self.makeSections(category: category, notes: notes)
            return Mutation.setSections(category: category, sections: sections)
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
    
    private func makeSections(category: MyNoteCategoryType, notes: [MyNoteModel]) -> [MyNoteSectionModel] {
        let notice = MyNoteSectionModel.notice(items: [.notice(category)])
        let noteItems = notes.map { MyNoteSectionItem.note($0) }
        let notesSection = MyNoteSectionModel.myNotes(items: noteItems)
        return [notice, notesSection]
    }
}
