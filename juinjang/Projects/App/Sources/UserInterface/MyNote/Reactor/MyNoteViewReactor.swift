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
        case appendNotes(category: MyNoteCategoryType,
                         notes: [MyNoteModel])
        case hideNotice(index: Int)
        case updateFilter(category: MyNoteCategoryType,
                          transactionType: TransactionTypeAction?,
                          saleType: SaleTypeAction?)
    }

    struct State {
        var categoryState: MyNoteCategoryType = .share
        var sharePageState = NotesPageState()
        var ownPageState = NotesPageState()
        var likePageState = NotesPageState()
        var pages: [MyNotePageModel] = [
            MyNotePageModel(
                category: .share,
                isShowingNotice: true,
                transactionType: .total,
                saleType: .totalSale,
                items: []
            ),
            MyNotePageModel(
                category: .own,
                isShowingNotice: true,
                transactionType: .total,
                saleType: .totalSale,
                items: []
            ),
            MyNotePageModel(
                category: .like,
                isShowingNotice: true,
                transactionType: .total,
                saleType: .totalSale,
                items: []
            )
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
            return initialFetchNotes(for: currentState.categoryState)
        case .categoryButtonDidTap(let index):
            let category = MyNoteCategoryType(rawValue: index) ?? .share
            
            if !self.currentState.pages[category.rawValue].items.isEmpty {
                return .empty()
            }
            
            return .concat([
                .just(.setCategoryState(index)),
                initialFetchNotes(for: category)
            ])
        case .pageCellEventOccurred(event: let event):
            return handlePageCellEvent(event)
        }
    }

    // MARK: - Reduce
    func reduce(state: State,
                mutation: Mutation) -> State {
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
            
        case .hideNotice(let index):
            guard state.pages.indices.contains(index) else { return state }
            
            var page = state.pages[index]
            page.isShowingNotice = false
            
            state.pages[index] = page
            
        case .updateFilter(category: let category,
                           transactionType: let transactionType,
                           saleType: let saleType):
            state.pages = state.pages.map { page in
                guard page.category == category else { return page }
                
                var updatedPage = page
                
                if let saleType = saleType {
                    updatedPage.saleType = saleType.filter
                }
                
                if let transactionType = transactionType {
                    updatedPage.transactionType = transactionType.filter
                }
                
                return updatedPage
            }
        }
        
        return state
    }
    
    // MARK: - Fetch Notes
    private func initialFetchNotes(for category: MyNoteCategoryType) -> Observable<Mutation> {
        let pageState = getPageState(for: category)
        let offset = 0
        
        return dependency.myNoteRepository.fetchMyNotes(
            category: category,
            offset: offset,
            limit: pageState.limit
        ).map { notes in
            return Mutation.setPage(
                .init(category: category,
                      isShowingNotice: true,
                      transactionType: .total,
                      saleType: .totalSale,
                      items: notes)
            )
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
        case .likeButtonTap(let category):
            // 추가 예정
            return .empty()
            
        case .myNoteCellTap(let note):
            // 추가 예정
            return .empty()
            
        case .filterItemTap(let index,
                            let transactionTypeAction,
                            let saleTypeAction):
            // Reload with Filter Items 추가 예정
            return .just(
                .updateFilter(
                    category: MyNoteCategoryType(rawValue: index) ?? .share,
                    transactionType: transactionTypeAction,
                    saleType: saleTypeAction
                )
            )
            
        case .noticeCloseButtonTap(let index):
            return .just(.hideNotice(index: index))
        }
    }
}
