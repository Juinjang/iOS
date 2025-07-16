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
        case alertEventOccurred(event: AlertEventType, noteID: Int)
        case receivedNoteLikeChange(Int)
        case likedNoticeDidShow
    }
    
    enum Mutation {
        case setCategoryState(Int)
        case setPage(MyNotePageModel)
        case appendNotes(notes: [MyNoteModel])
        case hideNotice
        case showAlreadyLikedNotice(id: Int)
        case setLikeUpdate(id: Int)
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
        let noteRepository: SharedNoteRepositoryProtocol
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
        case let .alertEventOccurred(event, id):
            return .concat(
                (event == .confirm) ? cancelNoteLike(noteID: id) : .empty(),
                .just(.resetAlert)
            )
        case .receivedNoteLikeChange(let noteID):
            return .just(.setLikeUpdate(id: noteID))
        case .likedNoticeDidShow:
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
        case .showAlreadyLikedNotice(let id):
            state.alreadyLikedNoteId = id
        case .setLikeUpdate(id: let id):
            setLikeUpdate(&state, id: id)
        case .resetAlert:
            state.alreadyLikedNoteId = nil
        }
        
        return state
    }
}

// MARK: - Mutate Methods
extension MyNoteViewReactor {
    private func cancelNoteLike(noteID id: Int) -> Observable<Mutation> {
        return dependency.noteRepository
            .deleteNoteLike(noteID: id)
            .asObservable()
            .flatMap { _ in
                return Observable.concat([
                    .just(.resetAlert),
                    .just(.setLikeUpdate(id: id))
                ])
            }
            .catch { _ in
                return Observable.concat([
                    .just(.resetAlert)
                ])
            }
    }
    
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
            return handleFilterChange(
                transactionType: transactionTypeAction,
                saleType: saleTypeAction
            )
            
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
                    return dependency.noteRepository
                        .createNoteLike(noteID: id)
                        .asObservable()
                        .map { _ in
                            return .setLikeUpdate(id: id)
                        }
                }
            }
            
            return .empty()
        default: return .empty()
        }
    }
    
    // MARK: - Fetch Notes
    private func initialFetchNotes(for category: MyNoteCategoryType) -> Observable<Mutation> {
        let currentNoticeState = currentState.pages.first(where: { $0.category == category })?.isShowingNotice ?? true
        
        return dependency.noteRepository.retrieveMyNotes(
            param: MyNoteRequestDTO(
                noteType: category.toRequestType,
                propertyType: "",
                priceType: "",
                keyword: ""
            )
        ).map { notes in
            return Mutation.setPage(
                .init(category: category,
                      isShowingNotice: currentNoticeState,
                      transactionType: .total,
                      saleType: .totalSale,
                      items: notes.map { .init(model: $0) })
            )
        }.asObservable()
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
    
    private func handleFilterChange(
        transactionType: TransactionTypeAction?,
        saleType: SaleTypeAction?
    ) -> Observable<Mutation> {
        return .deferred { [weak self] in
            guard let self = self else { return .empty() }
            var tempState = self.currentState
            let (tx, sale) = self.updateFilter(&tempState,
                                               transactionType: transactionType,
                                               saleType: saleType)
            return self.fetchFilterNoteList(transaction: tx, sale: sale)
        }
    }
    
    private func fetchFilterNoteList(
        transaction: TransactionTypeAction?,
        sale: SaleTypeAction?
    ) -> Observable<Mutation> {
        let transactionType = transaction ?? .totalTransaction
        let saleType = sale ?? .totalSale
        let currentNoticeState = currentState.pages.first(where: { $0.category == currentState.categoryState })?.isShowingNotice ?? true
        
        return dependency
            .noteRepository
            .retrieveMyNotes(
                param: .init(
                    noteType: currentState.categoryState.toRequestType,
                    propertyType: saleType.toRequestType,
                    priceType: transactionType.toRequestType,
                    keyword: ""
                )
            )
            .asObservable()
            .map { notes in
                return .setPage(
                    .init(category: self.currentState.categoryState,
                          isShowingNotice: currentNoticeState,
                          transactionType: transactionType.filter,
                          saleType: saleType.filter,
                          items: notes.map { .init(model: $0) })
                )
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
    
    private func updateFilter(
        _ state: inout State,
        transactionType: TransactionTypeAction?,
        saleType: SaleTypeAction?
    ) -> (TransactionTypeAction, SaleTypeAction) {
        var finalTransactionType: TransactionTypeAction = .totalTransaction
        var finalSaleType: SaleTypeAction = .totalSale
        
        state.pages = state.pages.map { page in
            guard page.category == state.categoryState else { return page }
            var updatedPage = page
            
            let currentTransaction = updatedPage.transactionType.action as? TransactionTypeAction
            let currentSale = updatedPage.saleType.action as? SaleTypeAction
            
            let newTransaction = transactionType ?? currentTransaction ?? .totalTransaction
            let newSale = saleType ?? currentSale ?? .totalSale
            
            updatedPage.transactionType = newTransaction.filter
            updatedPage.saleType = newSale.filter
            
            // 최종 값 설정
            finalTransactionType = newTransaction
            finalSaleType = newSale
            
            return updatedPage
        }
        
        return (finalTransactionType, finalSaleType)
    }
    
    private func setLikeUpdate(_ state: inout State, id: Int) {
        var isUnliked = false

        state.pages = state.pages.map { page in
            var updatedPage = page
            updatedPage.items = page.items.map { item in
                guard item.sharedNoteId == id else { return item }
                var updated = item
                updated.isLike.toggle()
                if !updated.isLike {
                    isUnliked = true
                }
                return updated
            }
            return updatedPage
        }

        if isUnliked {
            state.pages = removeNote(withId: id, in: .like, from: state.pages)
        }
    }
    
    private func removeNote(withId id: Int,
                            in category: MyNoteCategoryType,
                            from pages: [MyNotePageModel]) -> [MyNotePageModel] {
        return pages.map { page in
            guard page.category == category else { return page }
            let newItems = page.items.filter { $0.sharedNoteId != id }
            
            return MyNotePageModel(
                category: page.category,
                isShowingNotice: page.isShowingNotice,
                transactionType: page.transactionType,
                saleType: page.saleType,
                items: newItems
            )
        }
    }
}

extension MyNoteViewReactor {
    func getNoteTitle(noteID: Int) -> String {
        return self.currentState.pages.first {
            $0.category == self.currentState.categoryState
        }?.items.first {
            $0.sharedNoteId == noteID
        }?.buildingName ?? ""
    }
}
