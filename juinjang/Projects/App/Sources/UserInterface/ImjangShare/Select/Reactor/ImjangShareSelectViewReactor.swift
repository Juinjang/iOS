//
//  ImjangShareSelectViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

import ReactorKit
import Foundation

final class ImjangShareSelectViewReactor: Reactor {
    // MARK: - Action
    enum Action {
        case viewDidLoad
        case moreButtonDidTap
        case cellDidTap(id: String)
    }
    
    // MARK: - Mutation
    enum Mutation {
        case updateSectionItems(section: ImjangShareSelectSection,
                                item: [ImjangShareSelectBaseCellItem])
        case updateNickname(nickname: String)
        case updateIsShowEmptyView(bool: Bool)
        case updateSelectItem(id: String)
    }
    
    // MARK: - State
    struct State {
        var sectionItems: [ImjangShareSelectSection: [ImjangShareSelectBaseCellItem]]
        var nickname: String
        var isShowEmptyView: Bool?
        var isActivatedNextButton: Bool
        var selectItem: ImjangShareSelectCellItem?
    }
    
    struct Dependency {
        let imjangShareRepository: ImjangShareRepositoryProcotol
        let userRepository: UserRepositoryProtocol
    }
    
    // MARK: - Properties
    let initialState: State = State(
        sectionItems: [:],
        nickname: "",
        isShowEmptyView: nil,
        isActivatedNextButton: false,
        selectItem: nil
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
            return .empty()
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
        }
        return newState
    }
}

// MARK: - Mutate Methods
extension ImjangShareSelectViewReactor {
    private func fetchUserNickname() -> Observable<Mutation> {
        return dependency
            .userRepository
            .getUserNickname()
            .map { .updateNickname(nickname: $0) }
    }
    
    private func createInitialSections() -> Observable<Mutation> {
        return dependency
            .imjangShareRepository
            .fetchShareSelectNote()
            .flatMap { models -> Observable<Mutation> in
                if models.isEmpty {
                    return .concat(
                        .just(.updateIsShowEmptyView(bool: true)),
                        self.createSection(section: .guide)
                    )
                } else {
                    return .concat(
                        .just(.updateIsShowEmptyView(bool: false)),
                        self.createSection(section: .guide),
                        self.createSection(section: .notice),
                        self.createSection(
                            section: .select,
                            models: models
                        )
                    )
                }
            }
    }
    
    private func createSection(
        section: ImjangShareSelectSection,
        models: [ImjangShareSelectModel] = []
    ) -> Observable<Mutation> {
        let items: [ImjangShareSelectBaseCellItem]
        
        switch section {
        case .guide:
            items = [.guide(.init(id: UUID().uuidString))]
        case .notice:
            items = [.notice(.init(id: UUID().uuidString))]
        case .select:
            items = models.map {
                .select(ImjangShareSelectCellItem(id: UUID().uuidString, model: $0))
            }
        }
        
        return .just(
            .updateSectionItems(
                section: section,
                item: items
            )
        )
    }
}


// MARK: - Reduce Methods
extension ImjangShareSelectViewReactor {
    private func updateSelectedItem(state: State, selectedId: String) -> State {
        var newState = state
        guard var items = newState.sectionItems[.select] else { return state }

        items = items.map {
            guard case let .select(item) = $0 else { return $0 }
            let isAlreadySelected = item.isSelected && item.id == selectedId
            let newItem = ImjangShareSelectCellItem(id: item.id, model: item.model)
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
