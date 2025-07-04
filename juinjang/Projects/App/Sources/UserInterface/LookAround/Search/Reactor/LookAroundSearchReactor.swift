//
//  LookAroundSearchReactor.swift
//  juinjang
//
//  Created by 조유진 on 3/25/25.
//

import ReactorKit
import UIKit

final class LookAroundSearchReactor: Reactor {
    var initialState = State()
    
    struct Dependency {
        let sharedNoteRepository: SharedNoteRepositoryProtocol
    }

    let dependency: Dependency
    private var currentPageCount = 0

    init(dependency: Dependency) {
      self.dependency = dependency
    }
    
    enum Action {
        case viewDidLoad
        case searchSummitButtonTapped(keyword: String)
        case searchKeywordTapped(keyword: String)
        case searchActive(Bool)
        case removeAllKeywordTapped
        case deleteKeywordButtonTapped(keyword: String)
        case filterTapped(SortAction?, TransactionTypeAction?, SaleTypeAction?)
        case moreButtonDidTap
        case heartButtonDidTap(sharedNoteId: Int)
    }
    
    enum Mutation {
        case setRecentSearchKeywordList([String])
        case setSearchExploreNotes([LookAroundSearchResultSectionModel])
        case setKeyword(String)
        case setFilterInfo(filterInfo: (sortAction: SortAction?,
                           transactionAction: TransactionTypeAction?,
                           saleTypeAction: SaleTypeAction?))
        case updateIsLastPage(Bool)
        case setCurrentPage(Int)
        case setIsFilterTapped(Bool)
    }
    
    struct State {
        var searchRequest = ExploreNoteRequestDTO(
            sort: SortAction.popularAction.toRequestType,
            propertyType: "",
            priceType: "",
            keyword: nil,
            page: 0,
            size: 10
        )
        var filterInfo: (sortAction: SortAction?,
                         transactionAction: TransactionTypeAction?,
                         saleTypeAction: SaleTypeAction?) = (.popularAction, nil, nil)
        var keyword: String? = nil
        var recentSearchKeywordList: [String] = []
        var searchResultList: [LookAroundSearchResultSectionModel] = []
        var isLastPage: Bool?
        var currentPage: Int = 0
        var filterTapped: Bool = false
    }
    
    private var currentNotesCount: Int = 0
    private var disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let list = getRecentSearchList()
            return .just(.setRecentSearchKeywordList(list))
            
        case .searchSummitButtonTapped(let keyword), .searchKeywordTapped(let keyword):
            saveSearchText(keyword)
            let searchKeywordlist = getRecentSearchList()
            return .concat([
                .just(.setRecentSearchKeywordList(searchKeywordlist)),
                .just(.setKeyword(keyword)),
                .just(.setCurrentPage(0)),
                .just(.setIsFilterTapped(false)),
                retrieveInitialExploreNotes(keyword: keyword)
            ])
            
        case .removeAllKeywordTapped:
            removeAllSearchKeyword()
            let list = getRecentSearchList()
            return .just(.setRecentSearchKeywordList(list))
            
        case .deleteKeywordButtonTapped(let keyword):
            deleteSearchKeyword(keyword)
            let list = getRecentSearchList()
            return .just(.setRecentSearchKeywordList(list))
        case .filterTapped(let sortAction, let transactionTypeAction, let saleTypeAction):
            let filterInfo = handleFilterTapped(
                sortAction: sortAction,
                transactionAction: transactionTypeAction,
                saleTypeAction: saleTypeAction
            )
            return .concat([
                .just(.setCurrentPage(0)),
                .just(.setFilterInfo(filterInfo: filterInfo)),
                .just(.setIsFilterTapped(true)),
                retrieveInitialExploreNotes(filterInfo: filterInfo, keyword: currentState.keyword ?? "")
            ])
        case .moreButtonDidTap:
            let nextPage = currentState.currentPage + 1
            return .concat([
                   .just(.setCurrentPage(nextPage)),
                   retrieveExploreNotes(filterInfo: currentState.filterInfo, page: nextPage)
               ])
        case .searchActive(let isActive):
            return handlerSearchActive(isActive: isActive)
        case .heartButtonDidTap(let sharedNoteId):
            return handleHeartButtonDidTap(sharedNoteId: sharedNoteId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setRecentSearchKeywordList(let list):
            newState.recentSearchKeywordList = list
        case .setSearchExploreNotes(let searchResultList):
            newState.searchResultList = searchResultList
        case .setFilterInfo(let filterInfo):
            newState.filterInfo = filterInfo
        case .updateIsLastPage(let isLastPage):
            newState.isLastPage = isLastPage
        case .setCurrentPage(let currentPage):
            newState.currentPage = currentPage
        case .setKeyword(let keyword):
            newState.keyword = keyword
        case .setIsFilterTapped(let filterTapped):
            newState.filterTapped = filterTapped
        }
        return newState
    }
    
    private func handlerSearchActive(isActive: Bool) -> Observable<Mutation> {
        if isActive {
            return .empty()
        } else {
            currentNotesCount = 0
            return .concat([
                .just(.setCurrentPage(0)),
                .just(.setSearchExploreNotes([]))
            ])
        }
    }
    
    private func handleFilterTapped(
        sortAction: SortAction?,
        transactionAction: TransactionTypeAction?,
        saleTypeAction: SaleTypeAction?
    ) -> (sortAction: SortAction?,
          transactionAction: TransactionTypeAction?,
          saleTypeAction: SaleTypeAction?) {
        var filterInfo = currentState.filterInfo
        
        if sortAction != nil {
            filterInfo.sortAction = sortAction
        }
        
        if transactionAction != nil {
            filterInfo.transactionAction = transactionAction
        }
        
        if saleTypeAction != nil {
            filterInfo.saleTypeAction = saleTypeAction
        }
        
        currentNotesCount = 0
        return filterInfo
    }
    
    private func retrieveExploreNotes(
        filterInfo: (sortAction: SortAction?,
                     transactionAction: TransactionTypeAction?,
                     saleTypeAction: SaleTypeAction?) = (.popularAction,nil,nil),
        page: Int = 0
    ) -> Observable<Mutation> {
        
        let request = ExploreNoteRequestDTO(
            sort: filterInfo.sortAction?.toRequestType ?? SortAction.popularAction.toRequestType,
            propertyType: filterInfo.saleTypeAction?.toRequestType ?? "",
            priceType: filterInfo.transactionAction?.toRequestType ?? "",
            keyword: currentState.keyword,
            page: page,
            size: 10
        )
        
        return dependency.sharedNoteRepository.retrieveExploreNotes(param: request)
            .asObservable()
            .map { dto in
                self.currentNotesCount += dto.notes.count
                let isLastPage = self.currentNotesCount >= dto.totalResults || dto.notes.isEmpty
                return (dto, isLastPage)
            }
            .flatMap { [weak self] dto, isLastPage -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                return .concat(
                    .just(.updateIsLastPage(isLastPage)),
                    .just(.setSearchExploreNotes(self.getSectionOfExploreNoteList(dto)))
                )
            }
    }
    
    private func retrieveInitialExploreNotes(
        filterInfo: (sortAction: SortAction?,
                     transactionAction: TransactionTypeAction?,
                     saleTypeAction: SaleTypeAction?) = (.popularAction,nil,nil),
        keyword: String
    ) -> Observable<Mutation> {
        
        let request = ExploreNoteRequestDTO(
            sort: filterInfo.sortAction?.toRequestType ?? SortAction.popularAction.toRequestType,
            propertyType: filterInfo.saleTypeAction?.toRequestType ?? "",
            priceType: filterInfo.transactionAction?.toRequestType ?? "",
            keyword: keyword,
            page: 0,
            size: 10
        )
        
        return dependency.sharedNoteRepository.retrieveExploreNotes(param: request)
            .asObservable()
            .map { dto in
                self.currentNotesCount += dto.notes.count
                let isLastPage = self.currentNotesCount >= dto.totalResults || dto.notes.isEmpty
                return (dto, isLastPage)
            }
            .flatMap { [weak self] dto, isLastPage -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                return .concat(
                    .just(.updateIsLastPage(isLastPage)),
                    .just(.setSearchExploreNotes(self.getInitialSectionOfExploreNotes(dto)))
                )
            }
    }
    
    private func getInitialSectionOfExploreNotes(_ exploreNoteResponse: ExploreNoteResponseDTO) -> [LookAroundSearchResultSectionModel] {
        let sectionOfLookAroundImjangData: [LookAroundSearchResultSectionModel] = [
            .imjangCountSection(items: [
                .imjangCountSection(imjangCount: exploreNoteResponse.totalResults)
            ]),
            .exploreNoteSection(header: "", items: exploreNoteSectionItems(exploreNoteResponse.notes))
        ]
        return sectionOfLookAroundImjangData
    }
    
    private func getSectionOfExploreNoteList(_ exploreNoteResponseDTO: ExploreNoteResponseDTO) -> [LookAroundSearchResultSectionModel] {
        let sections = currentState.searchResultList
        
        guard let lastIndex = sections.indices.last,
              case let .exploreNoteSection(_, items) = sections[lastIndex] else { return [] }
        
        var notes: [ExploreNoteModel] = items.compactMap { row in
              if case let .exploreNoteSection(model) = row {
                  return model
              }
              return nil
          }
        
        notes.append(contentsOf: exploreNoteResponseDTO.notes)
        
        let sectionOfLookAroundImjangData: [LookAroundSearchResultSectionModel] = [
            .imjangCountSection(items: [
                .imjangCountSection(imjangCount: exploreNoteResponseDTO.totalResults)
            ]),
            .exploreNoteSection(header: "", items: exploreNoteSectionItems(notes))
        ]
        return sectionOfLookAroundImjangData
    }
    
    private func exploreNoteSectionItems(_ notes: [ExploreNoteModel]) -> [LookAroundSearchResultSectionModel.Row] {
        return  notes.map {
            LookAroundSearchResultSectionModel.Row.exploreNoteSection(exploreNote: $0)
        }
    }
    
    private func handleHeartButtonDidTap(sharedNoteId: Int) -> Observable<Mutation> {
        var sections = currentState.searchResultList
        
        guard let lastIndex = sections.indices.last,
              case let .exploreNoteSection(header, items) = sections[lastIndex]
        else { return .empty() }
        
        var notes: [ExploreNoteModel] = items.compactMap { row in
              if case let .exploreNoteSection(model) = row { return model }
              return nil
          }
        
        if let index = notes.firstIndex(where: { $0.sharedNoteId == sharedNoteId }) {
            notes[index].isLiked.toggle()
            
            handleLikeNote(sharedNoteId: sharedNoteId, isLiked: notes[index].isLiked)
        }
        
        let updatedNotes: [LookAroundSearchResultSectionModel.Row] = notes.map { note in
            .exploreNoteSection(exploreNote: note)
        }
      
        sections[lastIndex] = .exploreNoteSection(header: header, items: updatedNotes)
        
        return .just(.setSearchExploreNotes(sections))
    }
    
    private func handleLikeNote(sharedNoteId: Int, isLiked: Bool) {
        if isLiked {
            dependency.sharedNoteRepository.createNoteLike(noteID: sharedNoteId)
                .asObservable()
                .subscribe(with: self) { owner, noteLikeDTO in
                    dump(noteLikeDTO)
                }
                .disposed(by: disposeBag)
            
        } else {
            dependency.sharedNoteRepository.deleteNoteLike(noteID: sharedNoteId)
                .subscribe(with: self) { owner, noteLikeDTO in
                    dump(noteLikeDTO)
                }
                .disposed(by: disposeBag)
        }
    }
    
    private func saveSearchText(_ keyword: String) {
        var keywordArray = UserDefaultManager.shared.lookAroundSearchKeywords
        
        if let index = keywordArray.firstIndex(where: { $0 == keyword }) {
            keywordArray.remove(at: index)
            keywordArray.insert(keyword, at: 0)
        } else {
            if keywordArray.count < 5 {
                keywordArray.insert(keyword, at: 0)
            } else {
                keywordArray.removeLast()
                keywordArray.insert(keyword, at: 0)
            }
        }
        
        UserDefaultManager.shared.lookAroundSearchKeywords = keywordArray
    }
    
    private func removeAllSearchKeyword() {
        UserDefaultManager.shared.clearKey(UserDefaultManager.UDKey.lookAroundSearchKeywords.rawValue)
    }
    
    private func deleteSearchKeyword(_ keyword: String) {
        var keywordArray = UserDefaultManager.shared.lookAroundSearchKeywords
        if let index = keywordArray.firstIndex(where: { $0 == keyword }) {
            keywordArray.remove(at: index)
            UserDefaultManager.shared.lookAroundSearchKeywords = keywordArray
        }
    }
    
    private func getRecentSearchList() -> [String] {
        return UserDefaultManager.shared.lookAroundSearchKeywords
    }
}

struct LookAroundImjangResult: Decodable {
    let totalResults: Int
    let notes: [LookAroundImjangNote]
}

struct LookAroundImjangNote: Decodable, Hashable {
    let sharedNoteId: Int
    let buildingName: String
    let propertyType: String
    let imageUrl: String
    let isPurchase: Bool
    let isLiked: Bool
    let rate: Double
    let type: String
    let price: String
    let pyong: Int
    let floor: String
    let address: String
    let ownerImageUrl: String
    let ownerNickname: String
    let monthAge: Int
    let viewCount: Int
}

