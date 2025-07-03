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
        case heartButtonDidTap(sharedNoteId: Int)
    }
    
    enum Mutation {
        case setExploreNotes([SectionOfExploreNote])
        case setFilterInfo(filterInfo: (sortAction: SortAction?,
                           transactionAction: TransactionTypeAction?,
                           saleTypeAction: SaleTypeAction?))
        case updateIsLastPage(Bool)
        case setCurrentPage(Int)
        case setCurrentNotesCount(Int)
        
        case setSectionOfExploreNotes([SectionOfExploreNote])
    }
    
    struct State {
        var sectionOfExploreNotes: [SectionOfExploreNote]?
        var filterInfo: (sortAction: SortAction?,
                         transactionAction: TransactionTypeAction?,
                         saleTypeAction: SaleTypeAction?)
        var isLastPage: Bool?
        var currentPage: Int
        var currentNotesCount: Int
    }
    
    var initialState: State = State(
        sectionOfExploreNotes: nil,
        filterInfo: (.popularAction,nil,nil),
        isLastPage: nil,
        currentPage: 0,
        currentNotesCount: 0
    )
    
    private var currentNotesCount: Int = 0
    
    private var disposeBag = DisposeBag()
    
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
                .just(.setCurrentNotesCount(0)),
                .just(.setFilterInfo(filterInfo: filterInfo)),
                retrieveInitialExploreNotes(filterInfo: filterInfo)
            ])
        case .retrieveExploreNotes:
            return retrieveInitialExploreNotes()
        case .moreButtonDidTap:
            let nextPage = currentState.currentPage + 1
            return .concat([
                   .just(.setCurrentPage(nextPage)),
                   retrieveExploreNotes(filterInfo: currentState.filterInfo, page: nextPage)
               ])
        case .heartButtonDidTap(let sharedNoteId):
            return handleHeartButtonDidTap(sharedNoteId: sharedNoteId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setExploreNotes(let sectionOfExploreNotes):
            newState.sectionOfExploreNotes = sectionOfExploreNotes
        case .setFilterInfo(let filterInfo):
            newState.filterInfo = filterInfo
        case .updateIsLastPage(let isLastPage):
            newState.isLastPage = isLastPage
        case .setCurrentPage(let currentPage):
            newState.currentPage = currentPage
        case .setSectionOfExploreNotes(let sectionOfExploreNotes):
            newState.sectionOfExploreNotes = sectionOfExploreNotes
        case .setCurrentNotesCount(let currentNotesCount):
            newState.currentNotesCount = currentNotesCount
        }
        return newState
    }
    
    private func handleHeartButtonDidTap(sharedNoteId: Int) -> Observable<Mutation> {
        var sections = currentState.sectionOfExploreNotes ?? []
        
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
        
        let updatedNotes: [SectionOfExploreNote.Row] = notes.map { note in
            .exploreNoteSection(exploreNote: note)
        }
      
        sections[lastIndex] = .exploreNoteSection(header: header, items: updatedNotes)
        
        return .just(.setSectionOfExploreNotes(sections))
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
    
    private func retrieveInitialExploreNotes(
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
                    .just(.setExploreNotes(self.getInitialSectionExploreNoteList(dto)))
                )
            }
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
                    .just(.setExploreNotes(self.getSectionExploreNoteList(dto)))
                )
            }
    }
    
    private func getInitialSectionExploreNoteList(_ exploreNoteResponseDTO: ExploreNoteResponseDTO) -> [SectionOfExploreNote] {
        let sectionOfExploreNotes: [SectionOfExploreNote] = [
            .contentsSection(items: [
                .contentsSection(content: .pencilShop),
                .contentsSection(content: .myNote)
            ]),
            .selectAreaSection(items: [
                .selectAreaSection(area: Area(si: "서울시", gu: "동작구", dong: nil))
            ]),
            .imjangCountSection(items: [.imjangCountSection(imjangCount: exploreNoteResponseDTO.totalResults)]),
            .exploreNoteSection(header: "", items: exploreNoteSectionList(noteList: exploreNoteResponseDTO.notes))
        ]
        return sectionOfExploreNotes
    }
    
    private func getSectionExploreNoteList(_ exploreNoteResponseDTO: ExploreNoteResponseDTO) -> [SectionOfExploreNote] {
        let sections = currentState.sectionOfExploreNotes ?? []
        
        guard let lastIndex = sections.indices.last,
              case let .exploreNoteSection(_, items) = sections[lastIndex] else { return [] }
        
        var notes: [ExploreNoteModel] = items.compactMap { row in
              if case let .exploreNoteSection(model) = row {
                  return model
              }
              return nil
          }
        
        notes.append(contentsOf: exploreNoteResponseDTO.notes)
        
        let sectionOfExploreNotes: [SectionOfExploreNote] = [
            .contentsSection(items: [
                .contentsSection(content: .pencilShop),
                .contentsSection(content: .myNote)
            ]),
            .selectAreaSection(items: [
                .selectAreaSection(area: Area(si: "서울시", gu: "동작구", dong: nil))
            ]),
            .imjangCountSection(items: [.imjangCountSection(imjangCount: exploreNoteResponseDTO.totalResults)]),
            .exploreNoteSection(header: "", items: exploreNoteSectionList(noteList: notes))
        ]
        return sectionOfExploreNotes
    }
    
    private func exploreNoteSectionList(noteList: [ExploreNoteModel]) -> [SectionOfExploreNote.Row] {
        let exploreNotes: [SectionOfExploreNote.Row] = noteList.map { note in
            return .exploreNoteSection(exploreNote: note)
        }
        return exploreNotes
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
