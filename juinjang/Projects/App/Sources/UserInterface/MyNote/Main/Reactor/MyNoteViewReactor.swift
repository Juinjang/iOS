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
        case alertEventOccurred(event: AlertEventType)
    }

    enum Mutation {
        case setCategoryState(Int)
        case setPage(MyNotePageModel)
        case appendNotes(notes: [MyNoteModel])
        case hideNotice
        case updateFilter(transactionType: TransactionTypeAction?,
                          saleType: SaleTypeAction?)
        case showAlreadyLikedNotice(id: Int)
        case setLikeTrue(id: Int)
        case resetAlert
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
        var alreadyLikedNoteId: Int? = nil
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
            return handleCategoryChange(index: index)
        case .pageCellEventOccurred(event: let event):
            return handlePageCellEvent(event)
        case .alertEventOccurred(event: let event):
            // like API Call
            return .just(.resetAlert)
        }
    }

    // MARK: - Reduce
    func reduce(state: State,
                mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCategoryState(let index):
            updateCategoryState(&state, index: index)
        case .setPage(let page):
            updatePage(&state, page: page)
        case let .appendNotes(notes):
            appendNotes(&state, notes: notes)
        case .hideNotice:
            hideNotice(&state)
        case .updateFilter(transactionType: let transactionType,
                           saleType: let saleType):
            updateFilter(&state,
                         transactionType: transactionType,
                         saleType: saleType)
        case .showAlreadyLikedNotice(let id):
            state.alreadyLikedNoteId = id
        case .setLikeTrue(id: let id):
            setLikeTrue(&state, id: id)
        case .resetAlert:
            state.alreadyLikedNoteId = nil
        }
        
        return state
    }
}

// MARK: - Mutate Methods
extension MyNoteViewReactor {
    private func handleCategoryChange(index: Int) -> Observable<Mutation> {
        let category = MyNoteCategoryType(rawValue: index) ?? .share
        
        if !self.currentState.pages[category.rawValue].items.isEmpty {
            return .just(.setCategoryState(index))
        }
        
        return .concat([
            .just(.setCategoryState(index)),
            initialFetchNotes(for: category)
        ])
    }
    
    private func handlePageCellEvent(_ event: MyNotePageEventType) -> Observable<Mutation> {
        switch event {
        case .filterItemTap(let transactionTypeAction,
                            let saleTypeAction):
            // Reload with Filter Items 추가 예정
            return .just(
                .updateFilter(
                    transactionType: transactionTypeAction,
                    saleType: saleTypeAction
                )
            ).delay(.milliseconds(180), scheduler: MainScheduler.instance)
            
        case .noticeCloseButtonTap:
            return .just(.hideNotice)
            
        case .cellEvent(let event):
            return handleMyNoteCellEvent(event)
        default:
            return .empty()
        }
    }
    
    private func handleMyNoteCellEvent(_ event: MyNoteCellEventType) -> Observable<Mutation> {
        switch event {
        case .likeButtonTap(let id):
            
            let category = currentState.categoryState
            let currentPage = currentState.pages[category.rawValue]
            
            if let item = currentPage.items.first(where: { $0.sharedNoteId == id }) {
                if item.isLike {
                    return .just(.showAlreadyLikedNotice(id: id))
                } else {
                    return .just(.setLikeTrue(id: id))
                }
            }
            
            return .empty()
        default: return .empty()
        }
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
                      items: notes.map { .init(model: $0) })
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
}

// MARK: - Reduce Methods
extension MyNoteViewReactor {
    private func updateCategoryState(_ state: inout State, index: Int) {
        state.categoryState = MyNoteCategoryType(rawValue: index) ?? .share
    }
    
    private func updatePage(_ state: inout State, page: MyNotePageModel) {
        state.pages = state.pages.map {
            $0.category == page.category ? page : $0
        }
    }
    
    private func appendNotes(_ state: inout State, notes: [MyNoteModel]) {
        switch state.categoryState {
        case .share:
            state.sharePageState.notes.append(contentsOf: notes)
        case .own:
            state.ownPageState.notes.append(contentsOf: notes)
        case .like:
            state.likePageState.notes.append(contentsOf: notes)
        }
    }
    
    private func hideNotice(_ state: inout State) {
        let index = state.categoryState.rawValue
        guard state.pages.indices.contains(index) else { return }
        state.pages[index].isShowingNotice = false
    }
    
    private func updateFilter(_ state: inout State,
                              transactionType: TransactionTypeAction?,
                              saleType: SaleTypeAction?) {
        state.pages = state.pages.map { page in
            guard page.category == state.categoryState else { return page }
            var updatedPage = page
            
            if let transactionType = transactionType {
                updatedPage.transactionType = transactionType.filter
            }
            if let saleType = saleType {
                updatedPage.saleType = saleType.filter
            }
            return updatedPage
        }
    }
    
    private func setLikeTrue(_ state: inout State, id: Int) {
        state.pages = state.pages.map { page in
            guard page.category == state.categoryState else { return page }
            var updatedPage = page
            updatedPage.items = page.items.map { item in
                guard item.sharedNoteId == id else { return item }
                var updated = item
                updated.isLike = true
                return updated
            }
            return updatedPage
        }
    }
}
