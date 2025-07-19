//
//  ImjangDetailViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 4/9/25.
//

import ReactorKit
import Foundation
import RxRelay

final class ImjangDetailViewReactor: Reactor {
    enum Action {
        case viewDidLoad
        case viewWillAppear
        case checkListCategoryDidTap(index: Int)
        case noteOpenButtonDidTap
        case expandImageButtonDidTap(index: Int)
        case likeButtonDidTap
        case screenRecordingChanged(isRecording: Bool)
        case reportReasonDidSelected(ReportReason)
        case reportButtonDidTap
        case purchaseButtonDidTap
        case didPurchasePencil(isSuccess: Bool)
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
        case updateBalancePencilCount(Int)
        case updateRequiredPencilCount(Int)
        case updatePurchasePencil(Bool)
        case updateTotalRate(Double)
        case updateBuildingName(String)
        case updateDidPurchasePencil(Bool)
        case updateTappedImageInfo(index: Int, DTOs: [ImageDto])
    }
    
    struct State {
        let title: String
        var sectionItems: [ImjangDetailSection: [ImjangDetailBaseCellItem]]
        var allCheckListItems: [ImjangDetailCheckListCellItem]
        var isOneRoom: Bool
        var isBuyer: Bool
        var isShowPencilAlert: Bool?
        var isShowNotBuyerAlert: Bool
        var isShowCaptureAlert: Bool?
        var reportReason: ReportReason?
        var isShowReportCompletedView: Bool?
        var balancePencilCount: Int = 0
        var requiredPencilCount: Int = 0
        var didPurchasePencil: Bool = false
        var totalRate: Double = 0.0
        var buildingName: String = ""
        var tappedImageInfo: (index: Int, DTOs: [ImageDto])?
    }
        
    struct Dependency {
        let id: Int
        let title: String
        let sharedNoteRepository: SharedNoteRepositoryProtocol
        let pencilShopRepository: PencilShopRepositoryProtocol
        let likeEventRelay: PublishRelay<Int>?
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
            isShowPencilAlert: nil,
            isShowNotBuyerAlert: false,
            isShowCaptureAlert: nil
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                requestBalancePencilCount(),
                fetchAllSectionData()
            )
        case .viewWillAppear:
            if currentState.didPurchasePencil {
                return .concat(
                    requestBalancePencilCount(),
                    fetchAllSectionData(),
                    .just(.updatePurchasePencil(false))
                )
            } else {
                return .empty()
            }
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
        case .expandImageButtonDidTap(index: let index):
            return currentState.isBuyer
            ? {
                let imageDTOs = extractImageDTO()
                return imageDTOs.isEmpty
                ? .empty()
                : .just(.updateTappedImageInfo(index: index, DTOs: imageDTOs))
            }()
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
        case .didPurchasePencil(let success):
            return .just(.updateDidPurchasePencil(success))
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
        case .updateBalancePencilCount(let count):
            newState.balancePencilCount = count
        case .updateRequiredPencilCount(let count):
            newState.requiredPencilCount = count
        case .updatePurchasePencil(let bool):
            newState.didPurchasePencil = bool
        case .updateTotalRate(let rate):
            newState.totalRate = rate
        case .updateBuildingName(let name):
            newState.buildingName = name
        case .updateDidPurchasePencil(let bool):
            newState.didPurchasePencil = bool
        case .updateTappedImageInfo(index: let index, DTOs: let urls):
            newState.tappedImageInfo = (index, urls)
        }
        return newState
    }
}

// MARK: - Mutate Methods
extension ImjangDetailViewReactor {
    private func fetchAllSectionData() -> Observable<Mutation> {
        return .concat(
            createSection(for: .info),
            createSection(for: .report),
            .deferred { [weak self] in
                guard let self = self else { return .empty() }
                return .concat(
                    self.currentState.isBuyer
                    ? self.createSection(for: .checkList)
                    : self.createCheckListHolderSection()
                )
            }
        )
    }
    
    private func requestBalancePencilCount() -> Observable<Mutation> {
        return dependency
            .pencilShopRepository
            .retrievePencilTotalBalance()
            .asObservable()
            .map { response in
                Mutation.updateBalancePencilCount(response.totalBalance)
            }
    }
    
    private func handlePurchase() -> Observable<Mutation> {
        return dependency
            .sharedNoteRepository
            .purchaseNote(noteID: dependency.id)
            .andThen(
                Observable.concat([
                    .just(.updateIsBuyer(true)),
                    .just(.updateIsBuyerInInfoSection(true)),
                    self.createSection(for: .checkList),
                    self.createSection(for: .review)
                ])
            )
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
        ? dependency.sharedNoteRepository.deleteNoteLike(noteID: self.dependency.id).asObservable()
        : dependency.sharedNoteRepository.createNoteLike(noteID: self.dependency.id).asObservable()
        
        return observable.map { [weak self] response in
            if let noteID = self?.dependency.id {
                self?.dependency.likeEventRelay?.accept(noteID)
            }

            return Mutation.updateIsLikedInInfoSection(isLiked: !isLiked, likedCount: response.count)
        }
    }
    
    private func createReport(reason: ReportReason) -> Observable<Mutation> {
        dependency.sharedNoteRepository
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
        let repository = dependency.sharedNoteRepository
        
        switch section {
        case .info:
            return repository
                .retrieveNoteDetail(noteID: self.dependency.id)
                .asObservable()
                .flatMap { model -> Observable<Mutation> in
                    let item = ImjangDetailBaseCellItem.info(
                        .init(
                            id: UUID().uuidString,
                            model: model
                        )
                    )
                    return Observable.from([
                        .updateRequiredPencilCount(model.requiredPencils ?? 0),
                        .updateBuildingName(model.buildingName),
                        .updateItem(section: .info, item: [item]),
                        .updateIsBuyer(model.isBuyer),
                        .updateIsOneRoom(
                            model.limjangPurpose == "RESIDENTIAL_PURPOSE" &&
                            (model.propertyType == "VILLA" || model.propertyType == "OFFICE_TEL")
                        )
                    ])
                }
        case .report:
            return repository
                .retrieveNoteDetailReport(noteId: self.dependency.id)
                .asObservable()
                .flatMap { model -> Observable<Mutation> in
                    let cellItem = ImjangDetailBaseCellItem.report(
                        .init(
                            id: UUID().uuidString,
                            model: model
                        )
                    )
                    
                    return .concat([
                        .just(.updateItem(section: .report, item: [cellItem])),
                        .just(.updateTotalRate(model.totalRate))
                    ])
                }
        case .checkList:
            return repository
                .retrieveNoteDetailCheckList(noteId: self.dependency.id)
                .asObservable()
                .flatMap { model -> Observable<Mutation> in
                    let items = model.checklistAnswers.filter {
                        $0.category != "DEADLINE"
                    }.map {
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
    }
    
    private func createCheckListHolderSection() -> Observable<Mutation> {
        return dependency
            .sharedNoteRepository
            .retrieveNoteDetailCheckList(noteId: dependency.id)
            .asObservable()
            .map { response in
                return .updateItem(
                    section: .checkList,
                    item: response.checklistAnswers.filter {
                        $0.category != "DEADLINE"
                    }.prefix(5).map { model in
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
    
    private func extractImageDTO() -> [ImageDto] {
        guard let item = self.currentState.sectionItems[.info]?.first,
              case let .info(infoCellItem) = item else {
            return []
        }
        return infoCellItem.model.images.enumerated().map { index, url in
            .init(imageId: index, imageUrl: url)
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
