//
//  UserRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 4/27/25.
//

import RxSwift

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

    func retrieveProfileIntroduction() -> Single<ProfileModel> {
        return UserAPI.getProfileIntroduction
            .request(BaseResponse<ProfileModel>.self, networkManager)
            .map { try $0.unwrap() }
    }

    func updateProfileIntroduction(text: String) -> Completable {
        return UserAPI.patchProfileIntroduction(text)
            .request(NoResultResponse.self, networkManager)
            .asCompletable()
    }
}
