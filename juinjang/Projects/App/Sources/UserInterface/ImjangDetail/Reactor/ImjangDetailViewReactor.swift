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
        case checkListCategoryDidTap(index: Int)
    }
    
    enum Mutation {
        case updateItem(section: ImjangDetailSection, item: [BaseCellItem])
        case updateAllCheckListItems(items: [ImjangDetailCheckListCellItem])
    }
    
    struct State {
        let title: String
        var sectionItems: [ImjangDetailSection: [BaseCellItem]]
        var allCheckListItems: [ImjangDetailCheckListCellItem]
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
            allCheckListItems: []
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
        case .checkListCategoryDidTap(index: let index):
            return .just(.updateItem(
                section: .checkList,
                item: self.currentState.allCheckListItems.filter {
                    $0.model.category == CheckListCategoryType(rawValue: index)?.title
                }
            ))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateItem(section, item):
            newState.sectionItems[section] = item
        case .updateAllCheckListItems(items: let items):
            newState.allCheckListItems = items
        }
        return newState
    }
}

// MARK: - Mutate Methods
extension ImjangDetailViewReactor {
    private func createSection(for section: ImjangDetailSection) -> Observable<Mutation> {
        let repository = dependency.repository
        
        let request: Observable<[BaseCellItem]>
        
        switch section {
        case .info:
            request = repository.fetchInfo()
                .map {
                    [ImjangDetailInfoCellItem(
                        id: UUID().uuidString,
                        model: $0
                    )]
                }
        case .report:
            request = repository.fetchReport()
                .map {
                    [ImjangDetailReportCellItem(
                        id: UUID().uuidString,
                        model: $0
                    )]
                }
        case .checkList:
            return repository.fetchCheckList()
                .flatMap { models -> Observable<Mutation> in
                    let items = models.map {
                        ImjangDetailCheckListCellItem(id: UUID().uuidString, model: $0)
                    }
                    return Observable.from([
                        .updateAllCheckListItems(items: items),
                        .updateItem(section: .checkList,
                                    item: items.filter {
                            $0.model.category == CheckListCategoryType(
                                rawValue: 0 // Default: 입지여건
                            )?.title
                        })
                    ])
                }
        case .review:
            request = repository.fetchReview()
                .map {
                    [ImjangDetailReviewCellItem(
                        id: UUID().uuidString,
                        model: $0
                    )]
                }
        }
        
        return request.map { .updateItem(section: section, item: $0) }
    }
}
