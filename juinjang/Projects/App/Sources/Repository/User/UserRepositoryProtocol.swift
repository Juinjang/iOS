//
//  UserRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/27/25.
//

import RxSwift

protocol UserRepositoryProtocol {
    func retrieveUserNickname() -> Single<String>
    func retrieveProfileIntroduction() -> Single<ProfileModel>
    func updateProfileIntroduction(text: String) -> Completable
    func regenerateAccesstoken() -> Single<RefreshDto> 
}
