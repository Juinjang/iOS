//
//  UserUsecaseProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift
import DomainModel

public protocol UserUsecaseProtocol {
    func fetchNickname() -> Single<String>
    func fetchProfile() -> Single<Profile>
    func updateIntroduction(_ text: String) -> Completable
    func refreshAccessToken() -> Single<Refresh>
}
