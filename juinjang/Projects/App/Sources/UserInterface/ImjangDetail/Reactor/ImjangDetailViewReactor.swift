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
        case purchaseButtonDidTap
    }
    
    enum Mutation {
        case updateItem(section: ImjangDetailSection, item: [ImjangDetailBaseCellItem])
        case updateAllCheckListItems(items: [ImjangDetailCheckListCellItem])
        case updateIsOneRoom(Bool)
        case updateIsBuyer(Bool)
        case updateIsShowPencilAlert
        case updateIsBuyerInInfoSection(Bool)
        case updateIsShowNotBuyerAlert
        case updateIsLikedInInfoSection(isLiked: Bool, likedCount: Int)
        case updateIsShowCaptureAlert
        case updateReportReason(ReportReason)
        case updateIsShowReportCompletedView
        case updateOwnPencilCount(Int)
        case updateRequiredPencilCount(Int)
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
        var ownPencilCount: Int = 0
        var requiredPencilCount: Int = 0
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
                        : .just(.updateIsShowPencilAlert),
                        
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
            return .just(.updateIsShowPencilAlert)
        case .expandImageButtonDidTap(index: _):
            return self.currentState.isBuyer
                ? .empty()
                : .just(.updateIsShowNotBuyerAlert)
        case .likeButtonDidTap:
            return likeButtonDidTap()
        case let .screenRecordingChanged(isRecording):
            return isRecording
            ? .just(.updateIsShowCaptureAlert)
            : .empty()
        case .reportReasonDidSelected(let reason):
            return .just(.updateReportReason(reason))
        case .reportButtonDidTap:
            return createReport(reason: self.currentState.reportReason!)
        case .purchaseButtonDidTap:
            return handlePurchase()
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
        case .updateIsShowPencilAlert:
            newState.isShowPencilAlert.toggle()
        case .updateIsBuyerInInfoSection(let bool):
            newState = updateBuyerInInfoSection(newState, isBuyer: bool)
        case .updateIsShowNotBuyerAlert:
            newState.isShowNotBuyerAlert.toggle()
        case let .updateIsLikedInInfoSection(isLiked, likedCount):
            newState = updateLikeInInfoSection(newState,
                                               isLiked: isLiked,
                                               likedCount: likedCount)
        case .updateIsShowCaptureAlert:
            newState.isShowCaptureAlert.toggle()
        case .updateReportReason(let reason):
            newState.reportReason = reason
        case .updateIsShowReportCompletedView:
            newState.isShowReportCompletedView.toggle()
        case .updateOwnPencilCount(let count):
            newState.ownPencilCount = count
        case .updateRequiredPencilCount(let count):
            newState.requiredPencilCount = count
        }
        return newState
    }
}

// MARK: - Mutate Methods
extension ImjangDetailViewReactor {
    private func handlePurchase() -> Observable<Mutation> {
        return dependency.repository
            .purchaseNote(noteID: dependency.id)
            .asObservable()
            .flatMap { [weak self] _ -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                
                return .concat([
                    .just(.updateIsBuyer(true)),
                    .just(.updateIsBuyerInInfoSection(true)),
                    self.createSection(for: .checkList),
                    self.createSection(for: .review)
                ])
            }
            .catch { _ -> Observable<Mutation> in
                return .just(.updateIsShowPencilAlert)
            }
    }
    
    private func likeButtonDidTap() -> Observable<Mutation> {
        guard let item = self.currentState.sectionItems[.info]?.first as? ImjangDetailBaseCellItem else {
            return .empty()
        }
        
        guard case let .info(infoModel) = item else {
            return .empty()
        }
        
        let isLiked = infoModel.model.isLiked
        
        let observable: Observable<NoteLikeDTO> = isLiked
        ? dependency.repository.deleteNoteLike(noteID: self.dependency.id).asObservable()
        : dependency.repository.createNoteLike(noteID: self.dependency.id).asObservable()
        
        return observable.map { response in
            Mutation.updateIsLikedInInfoSection(isLiked: !isLiked, likedCount: response.count)
        }
    }
    
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
                        // 내 보유 연필 API 등록 예정
                        .updateRequiredPencilCount(model.requiredPencils ?? 0),
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
                    let items = model.checklistAnswers.map {
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
                                      model: .init(rate: model.totalRate ?? 0.0,
                                                   review: model.review ?? ""))
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
        return dependency
            .repository
            .retrieveNoteDetailCheckList(noteId: dependency.id)
            .asObservable()
            .map { response in
                return .updateItem(
                    section: .checkList,
                    item: response.checklistAnswers.prefix(5).map { model in
                        ImjangDetailBaseCellItem.checkList(
                            ImjangDetailCheckListCellItem(
                                id: UUID().uuidString,
                                model: model
                            )
                        )
                    }
                )
            }
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
    
    private func updateLikeInInfoSection(_ state: State,
                                         isLiked: Bool,
                                         likedCount: Int) -> State {
        var newState = state
        guard case let .info(infoItem) = newState.sectionItems[.info]?.first else {
            return state
        }
        
        var updatedModel = infoItem.model
        updatedModel.likedCount = likedCount
        updatedModel.isLiked = isLiked
        
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
