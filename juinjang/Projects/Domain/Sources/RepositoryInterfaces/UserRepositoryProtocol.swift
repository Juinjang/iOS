//
//  UserRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/27/25.
//

import RxSwift

public protocol UserRepositoryProtocol {
    func retrieveUserNickname() -> Single<String>
    func retrieveProfileInfo() -> Single<Profile>
    func updateProfileIntroduction(text: String) -> Completable
    func regenerateAccesstoken() -> Single<Refresh>
}
