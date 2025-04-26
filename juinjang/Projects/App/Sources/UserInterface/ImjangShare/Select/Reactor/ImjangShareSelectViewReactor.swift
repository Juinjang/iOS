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
    }
    
    // MARK: - Mutation
    enum Mutation {
        case updateSectionItems(section: ImjangShareSelectSection, item: [ImjangShareSelectBaseCellItem])
    }
    
    // MARK: - State
    struct State {
        var sectionItems: [ImjangShareSelectSection: [ImjangShareSelectBaseCellItem]]
    }
    
    struct Dependency {
        let repository: ImjangShareRepositoryProcotol
    }
    
    // MARK: - Properties
    let initialState: State = State(sectionItems: [:])
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                createSection(for: .guide),
                createSection(for: .notice),
                createSection(for: .select)
            )
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateSectionItems(section, item):
            newState.sectionItems[section] = item
        }
        return newState
    }
}

// MARK: - Mutate Methods
extension ImjangShareSelectViewReactor {
    private func createSection(for section: ImjangShareSelectSection) -> Observable<Mutation> {
        let request: Observable<[ImjangShareSelectBaseCellItem]>
        switch section {
        case .guide:
            request = .just([
                .guide(.init(id: UUID().uuidString))
            ])
        case .notice:
            request = .just([
                .notice(.init(id: UUID().uuidString))
            ])
        case .select:
            request = dependency
                .repository
                .fetchShareSelectNote()
                .map { models in
                    models.map {
                        ImjangShareSelectBaseCellItem.select(
                            ImjangShareSelectCellItem(
                                id: UUID().uuidString,
                                model: $0
                            )
                        )
                    }
                }
        }
        
        return request.map {
            .updateSectionItems(section: section,
                                item: $0)
        }
    }
}
