//
//  LookAroundImjangReactor.swift
//  juinjang
//
//  Created by 조유진 on 3/11/25.
//

import ReactorKit
import UIKit
import Differentiator

final class LookAroundImjangReactor: Reactor {
    private let repository: LookAroundImjangRepository
    private var disposeBag = DisposeBag()
    var initialState: State = State()
    
    init(repository: LookAroundImjangRepository) {
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
