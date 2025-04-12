//
//  ImjangDetailViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 4/9/25.
//

import ReactorKit
import Foundation

final class ImjangDetailViewReactor: Reactor {
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case updateItem(section: ImjangDetailSection, item: BaseCellItem)
        case markSectionAppeared(ImjangDetailSection)
    }
    
    struct State {
        let title: String
        var sectionItems: [ImjangDetailSection: [BaseCellItem]]
        var appearedSections: Set<ImjangDetailSection>
    }
        
    struct Dependency {
        let id: Int
        let title: String
        let repository: ImjangDetailRepositoryProtocol
    }
    
    let initialState: State
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.initialState = State(
            title: dependency.title,
            sectionItems: [:],
            appearedSections: [.info, .report]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                createSection(for: .info),
                createSection(for: .report),
                createSection(for: .checkList),
                createSection(for: .review)
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateItem(section, item):
            newState.sectionItems[section] = [item]
        case .markSectionAppeared(let section):
            newState.appearedSections.insert(section)
        }
        return newState
    }
}

extension ImjangDetailViewReactor {
    private func createSection(for section: ImjangDetailSection) -> Observable<Mutation> {
        let repository = dependency.repository
        
        let request: Observable<BaseCellItem>
        
        switch section {
        case .info:
            request = repository.fetchInfo()
                .map {
                    ImjangDetailInfoCellItem(
                        id: UUID().uuidString,
                        model: $0
                    )
                }
        case .report:
            request = repository.fetchReport()
                .map {
                    ImjangDetailReportCellItem(
                        id: UUID().uuidString,
                        model: $0
                    )
                }
        case .checkList:
            request = repository.fetchCheckList()
                .map {
                    ImjangDetailCheckListCellItem(
                        id: UUID().uuidString,
                        model: $0
                    )
                }
        case .review:
            request = repository.fetchReview()
                .map {
                    ImjangDetailReviewCellItem(
                        id: UUID().uuidString,
                        model: $0
                    )
                }
        }
        
        return request.map { .updateItem(section: section, item: $0) }
    }
}
