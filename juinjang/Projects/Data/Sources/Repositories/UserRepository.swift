//
//  UserRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 4/27/25.
//

import RxSwift
import Data
import Domain

final class UserRepository: UserRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    func retrieveUserNickname() -> Single<String> {
        return .just(userDefault.nickname)
    }
    
    func retrieveProfileInfo() -> Single<Profile> {
        return UserAPI.getProfileInfo
            .request(BaseResponse<ProfileResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
    
    func updateProfileIntroduction(text: String) -> Completable {
        return UserAPI.patchProfileIntroduction(text)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
    
    func regenerateAccesstoken() -> Single<Refresh> {
        let refresh = Refresh.init(
            accessToken: userDefault.accessToken,
            refreshToken: userDefault.refreshToken,
            email: userDefault.email
        )
        
        return UserAPI.regenerateAccessToken(refresh)
            .request(BaseResponse<RefreshResponse>.self, networkManager)
            .map { try $0.unwrap() }
            .map { $0.toDomain() }
    }
}
