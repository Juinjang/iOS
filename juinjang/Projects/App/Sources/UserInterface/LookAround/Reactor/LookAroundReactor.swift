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
        case viewDidLoad
    }
    
    enum Mutation {
        case setExploreNotes(ExploreNoteResponseDTO)
    }
    
    struct State {
        var sectionOfExploreNotes: [SectionOfExploreNote]? = nil
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return retrieveExploreNotes()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setExploreNotes(let exploreNotes):
            state.sectionOfExploreNotes = getSectionLookAroundImjangDataList(exploreNotes)
        }
        return state
    }
    
    private func retrieveExploreNotes(_ request: ExploreNoteRequestDTO = ExploreNoteRequestDTO()) -> Observable<Mutation> {
        return dependency.sharedNoteRepository.retrieveExploreNotes(param: request)
            .asObservable()
            .flatMap { exploreNoteResponseDTO -> Observable<Mutation> in
                return .just(.setExploreNotes(exploreNoteResponseDTO))
            }
    }
    
    private func getSectionLookAroundImjangDataList(_ exploreNoteResponseDTO: ExploreNoteResponseDTO) -> [SectionOfExploreNote] {
        let exploreNotes: [SectionOfExploreNote.Row] = exploreNoteResponseDTO.notes.map { note in
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
