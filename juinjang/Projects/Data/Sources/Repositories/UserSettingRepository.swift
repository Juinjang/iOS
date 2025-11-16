//
//  UserSettingsRepository.swift
//  Data
//
//  Created by KimDongWoo on 10/15/25.
//

import RxSwift
import Data
import Domain

public final class UserSettingsRepository: UserSettingsRepositoryProtocol {
    private let manager: UserDefaultManager
    
    public init(manager: UserDefaultManager = .shared) {
        self.manager = manager
    }
    
    // MARK: - Arrays
    public func searchKeywords() -> Single<[String]> {
        .just(manager.searchKeywords)
    }
    
    public func saveSearchKeywords(_ values: [String]) -> Completable {
        .create { [weak self] o in
            self?.manager.searchKeywords = values
            o(.completed)
            return Disposables.create()
        }
    }
    
    public func lookAroundSearchKeywords() -> Single<[String]> {
        .just(manager.lookAroundSearchKeywords)
    }
    
    public func saveLookAroundSearchKeywords(_ values: [String]) -> Completable {
        .create { [weak self] o in
            self?.manager.lookAroundSearchKeywords = values
            o(.completed)
            return Disposables.create()
        }
    }
    
    // MARK: - Tokens
    public func accessToken() -> Single<String> {
        .just(manager.accessToken)
    }
    
    public func saveAccessToken(_ value: String) -> Completable {
        .create { [weak self] o in
            self?.manager.accessToken = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    public func refreshToken() -> Single<String> {
        .just(manager.refreshToken)
    }
    
    public func saveRefreshToken(_ value: String) -> Completable {
        .create { [weak self] o in
            self?.manager.refreshToken = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    // MARK: - Profile
    public func nickname() -> Single<String> {
        .just(manager.nickname)
    }
    
    public func saveNickname(_ value: String) -> Completable {
        .create { [weak self] o in
            self?.manager.nickname = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    public func profileImage() -> Single<Data?> {
        .just(manager.profileImage)
    }
    
    public func saveProfileImage(_ value: Data?) -> Completable {
        .create { [weak self] o in
            self?.manager.profileImage = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    // MARK: - Flags & Misc
    public func userStatus() -> Single<Bool> {
        .just(manager.userStatus)
    }
    
    public func saveUserStatus(_ value: Bool) -> Completable {
        .create { [weak self] o in
            self?.manager.userStatus = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    public func email() -> Single<String> {
        .just(manager.email)
    }
    
    public func saveEmail(_ value: String) -> Completable {
        .create { [weak self] o in
            self?.manager.email = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    public func isKakaoLogin() -> Single<Bool> {
        .just(manager.isKakaoLogin)
    }
    
    public func saveIsKakaoLogin(_ value: Bool) -> Completable {
        .create { [weak self] o in
            self?.manager.isKakaoLogin = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    public func identityToken() -> Single<String> {
        .just(manager.identityToken)
    }
    
    public func saveIdentityToken(_ value: String) -> Completable {
        .create { [weak self] o in
            self?.manager.identityToken = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    public func kakaoTargetId() -> Single<Int64> {
        .just(manager.kakaoTargetId)
    }
    
    public func saveKakaoTargetId(_ value: Int64) -> Completable {
        .create { [weak self] o in
            self?.manager.kakaoTargetId = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    public func appleAuthCode() -> Single<String> {
        .just(manager.appleAuthCode)
    }
    
    public func saveAppleAuthCode(_ value: String) -> Completable {
        .create { [weak self] o in
            self?.manager.appleAuthCode = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    public func agreeVersion() -> Single<String> {
        .just(manager.agreeVersion)
    }
    
    public func saveAgreeVersion(_ value: String) -> Completable {
        .create { [weak self] o in
            self?.manager.agreeVersion = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    public func isShowShareAlert() -> Single<Bool?> {
        .just(manager.isShowShareAlert)
    }
    
    public func setShowShareAlert(_ value: Bool?) -> Completable {
        .create { [weak self] o in
            self?.manager.isShowShareAlert = value
            o(.completed)
            return Disposables.create()
        }
    }
    
    // MARK: - Bulk
    public func clearAllUserData() -> Completable {
        .create { [weak self] o in
            self?.manager.removeUserInfo()
            o(.completed)
            return Disposables.create()
        }
    }
}
