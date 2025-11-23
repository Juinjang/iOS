//
//  UserUsecaseProtocol.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import RxSwift

public protocol UserUsecaseProtocol {
    func fetchNickname() -> Single<String>
    func fetchProfile() -> Single<Profile>
    func updateIntroduction(_ text: String) -> Completable
    func refreshAccessToken() -> Single<RefreshAuthToken>
}
