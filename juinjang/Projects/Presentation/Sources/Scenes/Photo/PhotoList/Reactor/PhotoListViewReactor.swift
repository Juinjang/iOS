//
//  PhotoListViewReactor.swift
//  juinjang
//
//  Created by KimDongWoo on 5/24/25.
//

import ReactorKit
import RxSwift
import Foundation

final class PhotoListViewReactor: Reactor {
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setPhotos([PhotoCellItem])
    }
    
    struct State {
        var photoList: [PhotoCellItem] = []
        var selectedPhotoID: Int? = nil
    }
    
    struct Dependency {
        let photos: [String]
    }
    
    // MARK: - Properties
    
    let initialState = State()
    
    private let dependency: Dependency
    
    // MARK: - Init
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - Mutate
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(
                .setPhotos(
                    dependency.photos.enumerated().map { index, urlString in
                        PhotoCellItem(id: "\(index)",
                                      imageUrl: urlString)
                    }
                )
            )
        }
    }
    
    // MARK: - Reduce
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setPhotos(let items):
            newState.photoList = items
        }
        return newState
    }
}

extension PhotoListViewReactor {
    func convertToImageDTOList() -> [ImageDto] {
        return currentState.photoList.map {
            $0.toDTO()
        }
    }
}
