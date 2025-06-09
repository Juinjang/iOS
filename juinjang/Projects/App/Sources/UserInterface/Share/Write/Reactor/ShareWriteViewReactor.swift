//
//  ShareWriteViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 5/3/25.
//

import ReactorKit
import RxSwift
import Foundation

final class ShareWriteViewReactor: Reactor {
    // MARK: - Action
    enum Action {
        case viewDidLoad
        case didTapNavigationButton(NavigationAction)
        case didTapSelectPulbicButton(Bool)
        case selectedImjangPeriod(ImjangPeriod)
        case editingBuildingName(String)
        case editingReviewContent(String)
        case uploadButtonDidTap
    }
    
    // MARK: - Mutation
    enum Mutation {
        case updateNickname(nickname: String)
        case updatePopViewTrigger
        case appendSectionItem(section: ShareWriteSection,
                               items: [ShareWriteBaseCellItem])
        case updateIsPublic(Bool)
        case updateImjangPeriod(ImjangPeriod)
        case updateBuildingName(String)
        case updateReviewContent(String)
        case updateShowCompletedView
    }
    
    // MARK: - State
    struct State {
        var nickname: String = ""
        var popViewTrigger: Observable<Void>? = nil
        var sectionItems: [ShareWriteSection: [ShareWriteBaseCellItem]] = [:]
        var buildingName: String = ""
        var isPublic: Bool = true
        var selectImjangPeriod: ImjangPeriod?
        var reviewContentText: String = ""
        var isActivatedUploadButton: Bool = false
        var isShowCompletedView: Bool? = nil
        
        mutating func evaluateUploadButtonState() {
            isActivatedUploadButton =
                !buildingName.isEmpty &&
                selectImjangPeriod != nil &&
                !reviewContentText.isEmpty
        }
    }
    
    struct Dependency {
        let selectedModel: ShareSelectModel
        let noteRepository: NoteRepositoryProtocol
        let userRepository: UserRepositoryProtocol
        let sharedNoteRepository: SharedNoteRepositoryProtocol
    }
    
    let initialState: State = .init()
    private let dependency: Dependency
    
    init(dependecy: Dependency) {
        self.dependency = dependecy
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let isEmpty = dependency.selectedModel.imageUrl?.isEmpty
            return .concat(
                fetchUserNickname(),
                createSection(type: .notice),
                createSection(type: .share),
                createSection(type: .building),
                (isEmpty ?? true) ? .empty() : createSection(type: .photo),
                createSection(type: .period),
                createSection(type: .review)
            )
        case .didTapNavigationButton(let action):
            return performPopIfNeeded(action: action)
        case .didTapSelectPulbicButton(let bool):
            return .just(.updateIsPublic(bool))
        case .selectedImjangPeriod(let period):
            return .just(.updateImjangPeriod(period))
        case .editingBuildingName(let text):
            return .just(.updateBuildingName(text))
        case .editingReviewContent(let text):
            return .just(.updateReviewContent(text))
        case .uploadButtonDidTap:
            return createShareableNote()
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateNickname(nickname: let nickname):
            newState.nickname = nickname
        case .updatePopViewTrigger:
            newState.popViewTrigger = .just(())
        case let .appendSectionItem(section, items):
            let existingItems = newState.sectionItems[section] ?? []
            newState.sectionItems[section] = existingItems + items
        case .updateIsPublic(let bool):
            newState = toggleIsPublicInPhotoSection(newState, bool: bool)
        case .updateImjangPeriod(let period):
            newState = updateImjangPeriod(newState, period)
            newState.evaluateUploadButtonState()
        case .updateBuildingName(let text):
            newState.buildingName = text
            newState.evaluateUploadButtonState()
        case .updateReviewContent(let text):
            newState.reviewContentText = text
            newState.evaluateUploadButtonState()
        case .updateShowCompletedView:
            newState.isShowCompletedView = true
        }
        
        return newState
    }
}

// MARK: - Mutate Methods
extension ShareWriteViewReactor {
    private func createShareableNote() -> Observable<Mutation> {
        return dependency
            .sharedNoteRepository
            .createSharedNote(
                noteID: self.dependency.selectedModel.noteId,
                param: .init(
                    buildingName: self.currentState.buildingName,
                    isImageShared: self.currentState.isPublic,
                    year: Int(self.currentState.selectImjangPeriod?.year ?? "0") ?? 0,
                    month: Int(self.currentState.selectImjangPeriod?.month ?? "0") ?? 0,
                    period: self.currentState.selectImjangPeriod?.phase ?? "",
                    review: self.currentState.reviewContentText
                )
            )
            .andThen(.just(.updateShowCompletedView))
    }
    
    private func fetchUserNickname() -> Observable<Mutation> {
        return dependency
            .userRepository
            .retrieveUserNickname()
            .asObservable()
            .map { .updateNickname(nickname: $0) }
    }
    
    private func performPopIfNeeded(action: NavigationAction) -> Observable<Mutation> {
        return action == .popButtonTap
        ? .just(.updatePopViewTrigger)
        : .empty()
    }
    
    private func createSection(type: ShareWriteSection) -> Observable<Mutation> {
        let item: ShareWriteBaseCellItem = {
            switch type {
            case .notice:
                return .notice(
                    ShareWriteNoticeCellItem(
                        id: UUID().uuidString,
                        model: self.dependency.selectedModel
                    )
                )
            case .share:
                return .share(
                    ShareWriteShareCellItem(
                        id: UUID().uuidString,
                        model: self.dependency.selectedModel
                    )
                )
            case .building:
                return .building(
                    ShareWriteBuildingCellItem(
                        id: UUID().uuidString
                    )
                )
            case .photo:
                return .photo(
                    ShareWritePhotoCellItem(
                        id: UUID().uuidString,
                        isPublic: self.currentState.isPublic
                    )
                )
            case .period:
                return .period(
                    ShareWritePeriodCellItem(
                        id: UUID().uuidString,
                        isDoneEdit: false,
                        periodModel: ImjangPeriod.from()
                    )
                )
            case .review:
                return .review(
                    ShareWriteReviewCellItem(
                        id: UUID().uuidString
                    )
                )
            }
        }()
        
        return .just(.appendSectionItem(section: type, items: [item]))
    }
}

// MARK: - Reduce Methods
extension ShareWriteViewReactor {
    private func toggleIsPublicInPhotoSection(_ state: State,
                                              bool: Bool) -> State {
        var newState = state
        
        guard let currentItem = newState.sectionItems[.photo]?.first,
              case let .photo(photoItem) = currentItem else {
            return state
        }
        
        let updatedItem = ShareWriteBaseCellItem.photo(.init(
            id: photoItem.id,
            isPublic: bool
        ))
        
        newState.sectionItems[.photo] = [updatedItem]
        return newState
    }
    
    private func updateImjangPeriod(_ state: State,
                                    _ period: ImjangPeriod) -> State {
        var newState = state
        
        guard let currentItem = newState.sectionItems[.period]?.first,
              case let .period(periodItem) = currentItem else {
            return state
        }
        
        let updatedItem = ShareWriteBaseCellItem.period(
            .init(id: periodItem.id,
                  isDoneEdit: true,
                  periodModel: period)
        )
        newState.selectImjangPeriod = period
        newState.sectionItems[.period] = [updatedItem]
        return newState
    }
}

// MARK: - ViewController
extension ShareWriteViewReactor {
    func getShareSelectModel() -> ShareSelectModel {
        return self.dependency.selectedModel
    }
}
