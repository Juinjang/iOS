import DomainUsecaseInterfaces
import DomainRepositoryInterfaces

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
    
    public func refreshAccessToken() -> Single<Refresh> {
        repository.regenerateAccesstoken()
    }
}
