//
//  ShareSelectViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

import ReactorKit
import Foundation

final class ShareSelectViewReactor: Reactor {
    // MARK: - Action
    enum Action {
        case viewDidLoad
        case moreButtonDidTap
        case cellDidTap(id: String)
    }
    
    // MARK: - Mutation
    enum Mutation {
        case updateSectionItems(section: ShareSelectSection,
                                item: [ShareSelectBaseCellItem])
        case updateNickname(nickname: String)
        case updateIsShowEmptyView(bool: Bool)
        case updateSelectItem(id: String)
        case updateIsLastPage(Bool)
        case addSectionItems(section: ShareSelectSection,
                             item: [ShareSelectBaseCellItem])
    }
    
    // MARK: - State
    struct State {
        var sectionItems: [ShareSelectSection: [ShareSelectBaseCellItem]]
        var nickname: String
        var isShowEmptyView: Bool?
        var isActivatedNextButton: Bool
        var selectItem: ShareSelectCellItem?
        var isLastPage: Bool?
    }
    
    struct Dependency {
        let noteRepository: NoteRepositoryProtocol
        let userRepository: UserRepositoryProtocol
    }
    
    // MARK: - Properties
    let initialState: State = State(
        sectionItems: [:],
        nickname: "",
        isShowEmptyView: nil,
        isActivatedNextButton: false,
        selectItem: nil,
        isLastPage: nil
    )
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                fetchUserNickname(),
                createInitialSections()
            )
        case .moreButtonDidTap:
            return fetchMoreSelectModel()
        case .cellDidTap(id: let id):
            return .just(.updateSelectItem(id: id))
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateSectionItems(section, item):
            newState.sectionItems[section] = item
        case let .updateNickname(nickname):
            newState.nickname = nickname
        case let .updateIsShowEmptyView(bool):
            newState.isShowEmptyView = bool
        case let .updateSelectItem(id):
            newState = updateSelectedItem(state: newState, selectedId: id)
        case .updateIsLastPage(let bool):
            newState.isLastPage = bool
        case let .addSectionItems(section, items):
            var existingItems = newState.sectionItems[section] ?? []
            existingItems.append(contentsOf: items)
            newState.sectionItems[section] = existingItems
        }
        return newState
    }
    
    private func createSectionItems(
        section: ShareSelectSection,
        models: [ShareSelectModel] = []
    ) -> [ShareSelectBaseCellItem] {
        switch section {
        case .guide:
            return [.guide(.init(id: UUID().uuidString))]
        case .notice:
            return [.notice(.init(id: UUID().uuidString))]
        case .select:
            return models.map {
                .select(ShareSelectCellItem(id: UUID().uuidString, model: $0))
            }
        }
    }
}

// MARK: - Mutate Methods
extension ShareSelectViewReactor {
    private func fetchUserNickname() -> Observable<Mutation> {
        return dependency
            .userRepository
            .retrieveUserNickname()
            .asObservable()
            .map { .updateNickname(nickname: $0) }
    }
    
    private func createInitialSections() -> Observable<Mutation> {
        return dependency
            .noteRepository
            .retrieveShareableNoteList()
            .asObservable()
            .flatMap { models -> Observable<Mutation> in
                if models.isEmpty {
                    return .concat(
                        .just(.updateIsShowEmptyView(bool: true)),
                        .just(.updateSectionItems(
                            section: .guide,
                            item: self.createSectionItems(section: .guide)
                        ))
                    )
                } else {
                    return .concat(
                        .just(.updateIsShowEmptyView(bool: false)),
                        .just(.updateSectionItems(
                            section: .guide,
                            item: self.createSectionItems(section: .guide)
                        )),
                        .just(.updateSectionItems(
                            section: .notice,
                            item: self.createSectionItems(section: .notice)
                        )),
                        .just(.updateSectionItems(
                            section: .select,
                            item: self.createSectionItems(section: .select, models: models)
                        ))
                    )
                }
            }
    }
    
    private func fetchMoreSelectModel() -> Observable<Mutation> {
        return dependency
            .noteRepository
            .retrieveShareableNoteList()
            .asObservable()
            .flatMap { models -> Observable<Mutation> in
                let pageSize = 10
                let isLastPage = models.count < pageSize || models.isEmpty
                
                return .concat(
                    .just(.updateIsLastPage(isLastPage)),
                    .just(.addSectionItems(
                        section: .select,
                        item: self.createSectionItems(section: .select, models: models)
                    ))
                )
            }
    }
}


// MARK: - Reduce Methods
extension ShareSelectViewReactor {
    private func updateSelectedItem(state: State, selectedId: String) -> State {
        var newState = state
        guard var items = newState.sectionItems[.select] else { return state }

        items = items.map {
            guard case let .select(item) = $0 else { return $0 }
            let isAlreadySelected = item.isSelected && item.id == selectedId
            let newItem = ShareSelectCellItem(id: item.id, model: item.model)
            newItem.isSelected = !isAlreadySelected && item.id == selectedId
            return .select(newItem)
        }
        
        newState.sectionItems[.select] = items
        newState.selectItem = items
            .compactMap {
                if case let .select(item) = $0, item.isSelected {
                    return item
                }
                return nil
            }
            .first
        
        newState.isActivatedNextButton = newState.selectItem != nil

        return newState
    }
}
