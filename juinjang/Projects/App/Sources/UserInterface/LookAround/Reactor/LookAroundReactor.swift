//
//  LookAroundReactor.swift
//  juinjang
//
//  Created by 조유진 on 3/11/25.
//

import ReactorKit
import UIKit
import Differentiator

final class LookAroundReactor: Reactor {
    var initialState: State = State()
    
    struct Dependency {
        let sharedNoteRepository: SharedNoteRepositoryProtocol
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Action {
        case filterTapped(SortAction?, TransactionTypeAction?, SaleTypeAction?)
        case retrieveExploreNotes
        case moreButtonDidTap
    }
    
    enum Mutation {
        case setExploreNotes(ExploreNoteResponseDTO)
        case setFilterInfo(filterInfo: (sortAction: SortAction?,
                           transactionAction: TransactionTypeAction?,
                           saleTypeAction: SaleTypeAction?))
        case updateIsLastPage(Bool)
        case setIshideMoreButton(Bool)
        case setCurrentPage(Int)
    }
    
    struct State {
        var sectionOfExploreNotes: [SectionOfExploreNote]? = nil
        var filterInfo: (sortAction: SortAction?,
                         transactionAction: TransactionTypeAction?,
                         saleTypeAction: SaleTypeAction?) = (.popularAction,nil,nil)
        var isLastPage: Bool?
        var isMoreButtonHidden: Bool = true
        var currentPage: Int = 0
    }
    
    private var currentNotesCount: Int = 0
    private var currentNoteList: [ExploreNoteModel] = []
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filterTapped(let sortAction, let transactionTypeAction, let saleTypeAction):
            let filterInfo = handleFilterTapped(
                sortAction: sortAction,
                transactionAction: transactionTypeAction,
                saleTypeAction: saleTypeAction
            )
            return .concat([
                .just(.setCurrentPage(0)),
                .just(.setFilterInfo(filterInfo: filterInfo)),
                retrieveExploreNotes(filterInfo: filterInfo)
            ])
        case .retrieveExploreNotes:
            return retrieveExploreNotes()
        case .moreButtonDidTap:
            let nextPage = currentState.currentPage + 1
            return .concat([
                   .just(.setCurrentPage(nextPage)),
                   retrieveExploreNotes(filterInfo: currentState.filterInfo, page: nextPage)
               ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setExploreNotes(let exploreNotes):
            state.sectionOfExploreNotes = getSectionExploreNoteList(exploreNotes)
            print(state.sectionOfExploreNotes?[3].items.count ?? 0)
        case .setFilterInfo(let filterInfo):
            state.filterInfo = filterInfo
        case .updateIsLastPage(let isLastPage):
            state.isLastPage = isLastPage
        case .setIshideMoreButton(let isHidden):
            print("hideMoreButton: \(isHidden)")
            state.isMoreButtonHidden = isHidden
        case .setCurrentPage(let currentPage):
            state.currentPage = currentPage
        }
        return state
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
        currentNoteList = []
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
            page: page,
            size: 10
        )
        
        dump(request)
        
        return dependency.sharedNoteRepository.retrieveExploreNotes(param: request)
            .asObservable()
            .flatMap { [weak self] exploreNoteResponseDTO -> Observable<Mutation> in
                print("totalResults: \(exploreNoteResponseDTO.totalResults)")
                
                self?.currentNotesCount += exploreNoteResponseDTO.notes.count
                let isLastPage = self?.currentNotesCount ?? 0 >= exploreNoteResponseDTO.totalResults || exploreNoteResponseDTO.notes.isEmpty
                print("\(exploreNoteResponseDTO.notes.count)개")
                
                return .concat(
                    .just(.updateIsLastPage(isLastPage)),
                    .just(.setExploreNotes(exploreNoteResponseDTO)),
                    .just(.setIshideMoreButton(isLastPage))
                )
            }
    }
    
    private func getSectionExploreNoteList(_ exploreNoteResponseDTO: ExploreNoteResponseDTO) -> [SectionOfExploreNote] {
        currentNoteList.append(contentsOf: exploreNoteResponseDTO.notes)
        let exploreNotes: [SectionOfExploreNote.Row] = currentNoteList.map { note in
            return .exploreNoteSection(exploreNote: note)
        }
        
        let sectionOfExploreNotes: [SectionOfExploreNote] = [
            .contentsSection(items: [
                .contentsSection(content: .pencilShop),
                .contentsSection(content: .myNote)
            ]),
            .selectAreaSection(items: [
                .selectAreaSection(area: Area(si: "서울시", gu: "동작구", dong: nil))
            ]),
            .imjangCountSection(items: [.imjangCountSection(imjangCount: exploreNoteResponseDTO.totalResults)]),
            .exploreNoteSection(header: "", items: exploreNotes)
        ]
        return sectionOfExploreNotes
    }
    
    private func initSectionExploreNoteList() {
        
    }
}

enum SectionOfExploreNote: SectionModelType, Hashable, Equatable {
    typealias ITEM = Row
    
    case contentsSection(items: [Row])
    case selectAreaSection(items: [Row])
    case imjangCountSection(items: [Row])
    case exploreNoteSection(header: String, items: [Row])
    
    enum Row: Hashable, Equatable {
        case contentsSection(content: LookAroundContent)
        case selectAreaSection(area: Area)
        case imjangCountSection(imjangCount: Int)
        case exploreNoteSection(exploreNote: ExploreNoteModel)
    }
    
    var items: [Row] {
        switch self {
            case .contentsSection(let items): return items
            case .selectAreaSection(let items): return items
            case .imjangCountSection(let items): return items
            case .exploreNoteSection(_, let items): return items
        }
    }
    
    init(original: SectionOfExploreNote, items: [Row]) {
        switch original {
        case .contentsSection( _):
        self = .contentsSection(items: items)

        case .selectAreaSection(_):
            self = .selectAreaSection(items: items)
      
        case .imjangCountSection(_):
            self = .imjangCountSection(items: items)
    
        case .exploreNoteSection(let header, _):
            self = .exploreNoteSection(header: header, items: items)
        }
    }
 }

enum LookAroundContent: CaseIterable, Hashable {
    case pencilShop
    case myNote
    
    var title: String {
        switch self {
        case .pencilShop: return "연필상점"
        case .myNote: return "마이노트"
        }
    }
    
    var iconImage: UIImage {
        switch self {
        case .pencilShop: return UIImage.ImjangList.pencil
        case .myNote: return UIImage.ImjangList.myNote
        }
    }
}

struct Area: Hashable {
    let si: String?
    let gu: String?
    let dong: [String]?
}
