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
    }
    
    // MARK: - Mutation
    enum Mutation {
        case updateNickname(nickname: String)
        case updatePopViewTrigger
        case appendSectionItem(section: ShareWriteSection,
                               items: [ShareWriteBaseCellItem])
        case updateIsPublic(Bool)
        case updateImjangPeriod(ImjangPeriod)
    }
    
    // MARK: - State
    struct State {
        var nickname: String = ""
        var popViewTrigger: Observable<Void>? = nil
        var isActivatedUploadButton: Bool = false
        var isPublic: Bool = true
        var isDonePeriodEdit: Bool = false
        var sectionItems: [ShareWriteSection: [ShareWriteBaseCellItem]] = [:]
        var selectImjangPeriod: ImjangPeriod?
    }
    
    struct Dependency {
        let selectedModel: ShareSelectModel
        let noteRepository: NoteRepositoryProtocol
        let userRepository: UserRepositoryProtocol
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
            return .concat(
                fetchUserNickname(),
                createSection(type: .notice),
                createSection(type: .share),
                createSection(type: .building),
                createSection(type: .photo),
                createSection(type: .time),
                createSection(type: .review)
            )
        case .didTapNavigationButton(let action):
            return performPopIfNeeded(action: action)
        case .didTapSelectPulbicButton(let bool):
            return .just(.updateIsPublic(bool))
        case .selectedImjangPeriod(let period):
            return .just(.updateImjangPeriod(period))
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
        }
        
        return newState
    }
}

// MARK: - Mutate Methods
extension ShareWriteViewReactor {
    private func fetchUserNickname() -> Observable<Mutation> {
        return dependency
            .userRepository
            .getUserNickname()
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
            case .time:
                return .time(
                    ShareWriteTimeCellItem(
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
        
        guard let currentItem = newState.sectionItems[.time]?.first,
              case let .time(timeItem) = currentItem else {
            return state
        }
        
        let updatedItem = ShareWriteBaseCellItem.time(
            .init(id: timeItem.id,
                  isDoneEdit: true,
                  periodModel: period)
        )
        newState.selectImjangPeriod = period
        newState.sectionItems[.time] = [updatedItem]
        return newState
    }
}
