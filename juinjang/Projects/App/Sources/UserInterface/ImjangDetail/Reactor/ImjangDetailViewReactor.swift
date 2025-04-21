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
        case noteOpenButtonDidTap
    }
    
    enum Mutation {
        case updateItem(section: ImjangDetailSection, item: [BaseCellItem])
        case updateAllCheckListItems(items: [ImjangDetailCheckListCellItem])
        case updateIsOneRoom(Bool)
        case updateIsBuyer(Bool)
        case updateIsShowPencilAlert(Bool)
        case updateIsBuyerInInfoSection(Bool)
    }
    
    struct State {
        let title: String
        var sectionItems: [ImjangDetailSection: [BaseCellItem]]
        var allCheckListItems: [ImjangDetailCheckListCellItem]
        var isOneRoom: Bool
        var isBuyer: Bool
        var isShowPencilAlert: Bool
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
            allCheckListItems: [],
            isOneRoom: false,
            isBuyer: false,
            isShowPencilAlert: false
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                createSection(for: .info),
                createSection(for: .report),
                .deferred { [weak self] in
                    guard let self = self else { return .empty() }
                    return .concat(
                        self.currentState.isBuyer
                        ? .empty()
                        : .just(.updateIsShowPencilAlert(true)),
                        
                        self.currentState.isBuyer
                        ? self.createSection(for: .checkList)
                        : self.createCheckListHolderSection(),
                        
                        self.currentState.isBuyer
                        ? self.createSection(for: .review)
                        : .empty()
                    )
                }
            )
        case .checkListCategoryDidTap(index: let index):
            return .just(.updateItem(
                section: .checkList,
                item: self.currentState.allCheckListItems.filter {
                    $0.model.category == CheckListCategoryType(rawValue: index)?.title
                }
            ))
        case .noteOpenButtonDidTap:
            return .concat(
                .just(.updateIsBuyer(true)),
                .just(.updateIsBuyerInInfoSection(true)),
                .deferred { [weak self] in
                    guard let self = self else { return .empty() }
                    return .concat(
                        createSection(for: .checkList),
                        createSection(for: .review)
                    )
                }
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateItem(section, item):
            newState.sectionItems[section] = item
        case .updateAllCheckListItems(items: let items):
            newState.allCheckListItems = items
        case .updateIsOneRoom(let bool):
            newState.isOneRoom = bool
        case .updateIsBuyer(let bool):
            newState.isBuyer = bool
        case .updateIsShowPencilAlert(let bool):
            newState.isShowPencilAlert = bool
        case .updateIsBuyerInInfoSection(let bool):
            newState = updateBuyerInInfoSection(newState, isBuyer: bool)
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
            return repository.fetchInfo()
                .flatMap { model -> Observable<Mutation> in
                    let item = ImjangDetailInfoCellItem(
                        id: UUID().uuidString,
                        model: model
                    )
                    return Observable.from([
                        .updateItem(section: .info, item: [item]),
                        .updateIsBuyer(model.isBuyer),
                        .updateIsOneRoom(model.isOneRoom)
                    ])
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
    
    private func createCheckListHolderSection() -> Observable<Mutation> {
        return Observable.just(
            .updateItem(
                section: .checkList,
                item: [
                    ImjangDetailCheckListCellItem(
                        id: UUID().uuidString,
                        model: .init(
                            answerId: 0,
                            questionId: 3,
                            category: "LOCATION_CONDITION",
                            limjangId: 0,
                            answer: "5",
                            answerType: "SCORE"
                        )
                    ),
                    ImjangDetailCheckListCellItem(
                        id: UUID().uuidString,
                        model: .init(
                            answerId: 1,
                            questionId: 4,
                            category: "LOCATION_CONDITION",
                            limjangId: 0,
                            answer: "6호선",
                            answerType: "DROPDOWN"
                        )
                    ),
                    ImjangDetailCheckListCellItem(
                        id: UUID().uuidString,
                        model: .init(
                            answerId: 2,
                            questionId: 20,
                            category: "LOCATION_CONDITION",
                            limjangId: 0,
                            answer: "2023년",
                            answerType: "DROPDOWN"
                        )
                    ),
                    ImjangDetailCheckListCellItem(
                        id: UUID().uuidString,
                        model: .init(
                            answerId: 3,
                            questionId: 11,
                            category: "LOCATION_CONDITION",
                            limjangId: 0,
                            answer: "3",
                            answerType: "SCORE"
                        )
                    ),
                    ImjangDetailCheckListCellItem(
                        id: UUID().uuidString,
                        model: .init(
                            answerId: 4,
                            questionId: 14,
                            category: "LOCATION_CONDITION",
                            limjangId: 0,
                            answer: "남향",
                            answerType: "DROPDOWN"
                        )
                    )
                ]
            )
        )
    }
}

// MARK: - Reduce Methods
extension ImjangDetailViewReactor {
    private func updateBuyerInInfoSection(_ state: State, isBuyer: Bool) -> State {
        var newState = state
        guard let infoItem = newState.sectionItems[.info]?.first as? ImjangDetailInfoCellItem else {
            return state
        }
        
        var updatedModel = infoItem.model
        updatedModel.isBuyer = isBuyer
        
        let updatedItem = ImjangDetailInfoCellItem(id: infoItem.id, model: updatedModel)
        newState.sectionItems[.info] = [updatedItem]
        
        return newState
    }
}
