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
        case expandImageButtonDidTap(index: Int)
        case likeButtonDidTap
        case screenRecordingChanged(isRecording: Bool)
        case reportReasonDidSelected(ReportReason)
        case reportButtonDidTap
    }
    
    enum Mutation {
        case updateItem(section: ImjangDetailSection, item: [ImjangDetailBaseCellItem])
        case updateAllCheckListItems(items: [ImjangDetailCheckListCellItem])
        case updateIsOneRoom(Bool)
        case updateIsBuyer(Bool)
        case updateIsShowPencilAlert(Bool)
        case updateIsBuyerInInfoSection(Bool)
        case updateIsShowNotBuyerAlert(Bool)
        case updateIsLikedInInfoSection
        case updateIsShowCaptureAlert(Bool)
        case updateReportReason(ReportReason)
        case updateIsShowReportCompletedView
    }
    
    struct State {
        let title: String
        var sectionItems: [ImjangDetailSection: [ImjangDetailBaseCellItem]]
        var allCheckListItems: [ImjangDetailCheckListCellItem]
        var isOneRoom: Bool
        var isBuyer: Bool
        var isShowPencilAlert: Bool
        var isShowNotBuyerAlert: Bool
        var isShowCaptureAlert: Bool?
        var reportReason: ReportReason?
        var isShowReportCompletedView: Bool?
    }
        
    struct Dependency {
        let id: Int
        let title: String
        let repository: SharedNoteRepositoryProtocol
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
            isShowPencilAlert: false,
            isShowNotBuyerAlert: false,
            isShowCaptureAlert: nil
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
                        : self.createCheckListHolderSection()
                    )
                }
            )
        case .checkListCategoryDidTap(index: let index):
            return .just(.updateItem(
                section: .checkList,
                item: self.currentState.allCheckListItems.filter {
                    $0.model.category == CheckListCategoryType(rawValue: index)?.title
                }.map {
                    ImjangDetailBaseCellItem.checkList(.init(id: $0.id, model: $0.model))
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
        case .expandImageButtonDidTap(index: _):
            return self.currentState.isBuyer
                ? .empty()
                : .just(.updateIsShowNotBuyerAlert(!self.currentState.isShowNotBuyerAlert))
        case .likeButtonDidTap:
            return .just(
                .updateIsLikedInInfoSection
            )
        case let .screenRecordingChanged(isRecording):
            return isRecording
            ? .just(.updateIsShowCaptureAlert(!(self.currentState.isShowCaptureAlert ?? true)))
            : .empty()
        case .reportReasonDidSelected(let reason):
            return .just(.updateReportReason(reason))
        case .reportButtonDidTap:
            return createReport(reason: self.currentState.reportReason!)
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
        case .updateIsShowNotBuyerAlert(let bool):
            newState.isShowNotBuyerAlert = bool
        case .updateIsLikedInInfoSection:
            break
        case .updateIsShowCaptureAlert(let bool):
            newState.isShowCaptureAlert = bool
        case .updateReportReason(let reason):
            newState.reportReason = reason
        case .updateIsShowReportCompletedView:
            newState.isShowReportCompletedView = !(state.isShowReportCompletedView ?? false)
        }
        return newState
    }
}

// MARK: - Mutate Methods
extension ImjangDetailViewReactor {
    private func createReport(reason: ReportReason) -> Observable<Mutation> {
        dependency.repository
            .createNoteReport(
                param: .init(
                    sharedNoteId: self.dependency.id,
                    type: reason.rawValue
                )
            )
            .andThen(Single.just(Mutation.updateIsShowReportCompletedView))
            .asObservable()
            .catch { _ in Observable.empty() }
    }
    
    private func createSection(for section: ImjangDetailSection) -> Observable<Mutation> {
        let repository = dependency.repository
        let request: Observable<[ImjangDetailBaseCellItem]>
        
        switch section {
        case .info:
            return repository.retrieveNoteDetail(noteID: self.dependency.id)
                .asObservable()
                .flatMap { model -> Observable<Mutation> in
                    let item = ImjangDetailBaseCellItem.info(
                        .init(
                            id: UUID().uuidString,
                            model: model
                        )
                    )
                    return Observable.from([
                        .updateItem(section: .info, item: [item]),
                        .updateIsBuyer(model.isBuyer),
                        .updateIsOneRoom(
                            model.propertyType == "VILLA" || model.propertyType == "OFFICE_TEL"
                        )
                    ])
                }
        case .report:
            request = repository.retrieveNoteDetailReport(noteId: self.dependency.id)
                .asObservable()
                .map {
                    [ImjangDetailBaseCellItem.report(
                        .init(
                            id: UUID().uuidString,
                            model: $0
                        )
                    )]
                }
        case .checkList:
            return repository.retrieveNoteDetailCheckList(noteId: self.dependency.id)
                .asObservable()
                .flatMap { model -> Observable<Mutation> in
                    let items = model.checkListAnswerList.map {
                        ImjangDetailCheckListCellItem(id: UUID().uuidString, model: $0)
                    }
                    
                    return Observable.concat([
                        .just(.updateAllCheckListItems(items: items)),
                        .just(.updateItem(
                            section: .checkList,
                            item: items.filter {
                                $0.model.category == CheckListCategoryType(
                                    rawValue: 0 // Default: 입지여건
                                )?.title
                            }.map {
                                ImjangDetailBaseCellItem.checkList(
                                    .init(id: $0.id, model: $0.model)
                                )
                            }
                        )),
                        self.currentState.isBuyer
                        ? .just(.updateItem(
                            section: .review,
                            item: [ImjangDetailBaseCellItem.review(
                                .init(id: UUID().uuidString,
                                      model: .init(rate: model.totalRate,
                                                   review: model.review))
                            )]
                        ))
                        : .empty()
                    ])
                }
        default: return .empty()
        }
        
        return request.map { .updateItem(section: section, item: $0) }
    }
    
    private func createCheckListHolderSection() -> Observable<Mutation> {
        return Observable.just(
            .updateItem(
                section: .checkList,
                item: [
                    ImjangDetailBaseCellItem.checkList(
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
                        )
                    ),
                    ImjangDetailBaseCellItem.checkList(
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
                        )
                    ),
                    ImjangDetailBaseCellItem.checkList(
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
                        )
                    ),
                    ImjangDetailBaseCellItem.checkList(
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
                        )
                    ),
                    ImjangDetailBaseCellItem.checkList(
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
        guard case let .info(infoItem) = newState.sectionItems[.info]?.first else {
            return state
        }
        
        var updatedModel = infoItem.model
        updatedModel.isBuyer = isBuyer
        
        let updatedItem = ImjangDetailBaseCellItem.info(
            ImjangDetailInfoCellItem(
                id: infoItem.id,
                model: updatedModel
            )
        )
        
        newState.sectionItems[.info] = [updatedItem]
        
        return newState
    }
}

extension Dictionary where Key == ImjangDetailSection, Value == [ImjangDetailBaseCellItem] {
    func infoItem() -> ImjangDetailInfoCellItem? {
        guard let item = self[.info]?.first else { return nil }
        if case let .info(infoItem) = item {
            return infoItem
        }
        return nil
    }
}
