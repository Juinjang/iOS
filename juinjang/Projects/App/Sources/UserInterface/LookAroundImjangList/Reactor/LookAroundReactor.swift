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
    private let repository: LookAroundRepository
    
    var initialState: State = State()
    
    init(repository: LookAroundRepository) {
        self.repository = repository
    }
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setLookAroundItems(LookAroundImjangResult)
    }
    
    struct State {
        var sectionOfLookAroundImjangData: [SectionOfLookAroundImjangData]? = nil
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return repository.fetchLookAroundImjang()
                .map {
                    Mutation.setLookAroundItems($0)
                }
                .debug("mutate viewDidLoad")
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setLookAroundItems(let lookAroundImjangResult):
            state.sectionOfLookAroundImjangData = getSectionLookAroundImjangDataList(lookAroundImjangResult)
        }
        return state
    }
    
    private func getSectionLookAroundImjangDataList(_ lookAroundImjangResult: LookAroundImjangResult) -> [SectionOfLookAroundImjangData] {
        let imjangListSectionList: [SectionOfLookAroundImjangData.Row] = lookAroundImjangResult.notes.map { lookAroundImjang in
            return .imjangListSection(lookAroundImjang: lookAroundImjang)
        }
        
        let sectionOfLookAroundImjangData: [SectionOfLookAroundImjangData] = [
            .contentsSection(items: [.contentsSection(content: .pencilShop), .contentsSection(content: .myNote)]),
            .selectAreaSection(items: [.selectAreaSection(area: Area(si: "서울시", gu: "동작구", dong: nil))]),
            .imjangCountSection(items: [.imjangCountSection(imjangCount: lookAroundImjangResult.totalResults)]),
            .imjangListSection(header: "", items: imjangListSectionList)
        ]
        return sectionOfLookAroundImjangData
    }
}

enum SectionOfLookAroundImjangData: SectionModelType {
    typealias ITEM = Row
    
    case contentsSection(items: [Row])
    case selectAreaSection(items: [Row])
    case imjangCountSection(items: [Row])
    case imjangListSection(header: String, items: [Row])
    
    enum Row {
        case contentsSection(content: LookAroundContent)
        case selectAreaSection(area: Area)
        case imjangCountSection(imjangCount: Int)
        case imjangListSection(lookAroundImjang: LookAroundImjangNote)
    }
    
    var items: [Row] {
        switch self {
            case .contentsSection(let items): return items
            case .selectAreaSection(let items): return items
            case .imjangCountSection(let items): return items
            case .imjangListSection(_, let items): return items
        }
    }
    
    init(original: SectionOfLookAroundImjangData, items: [Row]) {
    switch original {
    case .contentsSection( _):
        self = .contentsSection(items: items)

    case .selectAreaSection(_):
        self = .selectAreaSection(items: items)
      
    case .imjangCountSection(_):
        self = .imjangCountSection(items: items)
    
    case .imjangListSection(let header, _):
        self = .imjangListSection(header: header, items: items)
    }
  }
 }

enum LookAroundContent: CaseIterable {
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

struct userProfile {
    let userNickname: String
    let profileImageUrl: String
}


struct Area {
    let si: String?
    let gu: String?
    let dong: [String]?
}

enum PropertyType: String, CaseIterable {
    case APARTMENT
    case VILLA
    case OFFICE_TEL
    case DETACHED_HOUSE
    
    var image: UIImage {
        switch self {
        case .APARTMENT: return .ImjangList.apartment
        case .VILLA: return .ImjangList.villa
        case .OFFICE_TEL: return .ImjangList.officeTel
        case .DETACHED_HOUSE: return .ImjangList.detachedHouse
        }
    }
}
