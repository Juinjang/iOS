//
//  UserUsecase.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import RxSwift

public final class UserUsecase: UserUsecaseProtocol {
    private let repository: UserRepositoryProtocol
    
    public init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchNickname() -> Single<String> {
        repository.retrieveUserNickname()
    }
    
    public func fetchProfile() -> Single<Profile> {
        repository.retrieveProfileInfo()
    }
    
    public func updateIntroduction(_ text: String) -> Completable {
        repository.updateProfileIntroduction(text: text)
    }
    
    public func refreshAccessToken() -> Single<RefreshAuthToken> {
        repository.regenerateAccesstoken()
    }
}
