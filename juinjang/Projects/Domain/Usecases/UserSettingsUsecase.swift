//
//  UserSettingsUsecase.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import DomainModel
import DomainUsecaseInterfaces
import DomainRepositoryInterfaces

public final class UserSettingsUsecase: UserSettingsUsecaseProtocol {
    private let repository: UserSettingsRepositoryProtocol
    
    public init(repository: UserSettingsRepositoryProtocol) {
        self.repository = repository
    }

    public func loadSearchKeywords() -> Single<[String]> {
        repository.searchKeywords()
    }
    
    public func updateSearchKeywords(_ keywords: [String]) -> Completable {
        repository.saveSearchKeywords(keywords)
    }

    public func loadLookAroundSearchKeywords() -> Single<[String]> {
        repository.lookAroundSearchKeywords()
    }
    
    public func updateLookAroundSearchKeywords(_ keywords: [String]) -> Completable {
        repository.saveLookAroundSearchKeywords(keywords)
    }

    public func loadAccessToken() -> Single<String> {
        repository.accessToken()
    }
    
    public func updateAccessToken(_ token: String) -> Completable {
        repository.saveAccessToken(token)
    }

    public func loadRefreshToken() -> Single<String> {
        repository.refreshToken()
    }
    
    public func updateRefreshToken(_ token: String) -> Completable {
        repository.saveRefreshToken(token)
    }

    public func loadNickname() -> Single<String> {
        repository.nickname()
    }
    
    public func updateNickname(_ value: String) -> Completable {
        repository.saveNickname(value)
    }

    public func loadProfileImage() -> Single<UIImage?> {
        repository.profileImage()
    }
    
    public func updateProfileImage(_ image: UIImage?) -> Completable {
        repository.saveProfileImage(image)
    }

    public func loadUserStatus() -> Single<Bool> {
        repository.userStatus()
    }
    
    public func updateUserStatus(_ value: Bool) -> Completable {
        repository.saveUserStatus(value)
    }

    public func loadEmail() -> Single<String> {
        repository.email()
    }
    
    public func updateEmail(_ value: String) -> Completable {
        repository.saveEmail(value)
    }

    public func loadIsKakaoLogin() -> Single<Bool> {
        repository.isKakaoLogin()
    }
    
    public func updateIsKakaoLogin(_ value: Bool) -> Completable {
        repository.saveIsKakaoLogin(value)
    }

    public func loadIdentityToken() -> Single<String> {
        repository.identityToken()
    }
    
    public func updateIdentityToken(_ value: String) -> Completable {
        repository.saveIdentityToken(value)
    }

    public func loadKakaoTargetId() -> Single<Int64> {
        repository.kakaoTargetId()
    }
    
    public func updateKakaoTargetId(_ value: Int64) -> Completable {
        repository.saveKakaoTargetId(value)
    }

    public func loadAppleAuthCode() -> Single<String> {
        repository.appleAuthCode()
    }
    
    public func updateAppleAuthCode(_ value: String) -> Completable {
        repository.saveAppleAuthCode(value)
    }

    public func loadAgreeVersion() -> Single<String> {
        repository.agreeVersion()
    }
    
    public func updateAgreeVersion(_ value: String) -> Completable {
        repository.saveAgreeVersion(value)
    }

    public func loadShareAlertFlag() -> Single<Bool?> {
        repository.isShowShareAlert()
    }
    
    public func setShareAlertFlag(_ value: Bool?) -> Completable {
        repository.setShowShareAlert(value)
    }

    public func loadHttpsEnabled() -> Single<Bool> {
        repository.isHttpsEnabled()
    }
    
    public func updateHttpsEnabled(_ value: Bool) -> Completable {
        repository.saveHttpsEnabled(value)
    }

    public func clearAll() -> Completable {
        repository.clearAllUserData()
    }
}
