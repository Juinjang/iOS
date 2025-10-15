//
//  UserSettingsUsecaseProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift
import DomainModel

public protocol UserSettingsUsecaseProtocol {
    func loadSearchKeywords() -> Single<[String]>
    func updateSearchKeywords(_ keywords: [String]) -> Completable

    func loadLookAroundSearchKeywords() -> Single<[String]>
    func updateLookAroundSearchKeywords(_ keywords: [String]) -> Completable

    func loadAccessToken() -> Single<String>
    func updateAccessToken(_ token: String) -> Completable

    func loadRefreshToken() -> Single<String>
    func updateRefreshToken(_ token: String) -> Completable

    func loadNickname() -> Single<String>
    func updateNickname(_ value: String) -> Completable

    func loadProfileImage() -> Single<Data?>
    func updateProfileImage(_ image: Data?) -> Completable

    func loadUserStatus() -> Single<Bool>
    func updateUserStatus(_ value: Bool) -> Completable

    func loadEmail() -> Single<String>
    func updateEmail(_ value: String) -> Completable

    func loadIsKakaoLogin() -> Single<Bool>
    func updateIsKakaoLogin(_ value: Bool) -> Completable

    func loadIdentityToken() -> Single<String>
    func updateIdentityToken(_ value: String) -> Completable

    func loadKakaoTargetId() -> Single<Int64>
    func updateKakaoTargetId(_ value: Int64) -> Completable

    func loadAppleAuthCode() -> Single<String>
    func updateAppleAuthCode(_ value: String) -> Completable

    func loadAgreeVersion() -> Single<String>
    func updateAgreeVersion(_ value: String) -> Completable

    func loadShareAlertFlag() -> Single<Bool?>
    func setShareAlertFlag(_ value: Bool?) -> Completable

    func loadHttpsEnabled() -> Single<Bool>
    func updateHttpsEnabled(_ value: Bool) -> Completable

    func clearAll() -> Completable
}
