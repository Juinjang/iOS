//
//  UserSettingsRepositoryProtocol.swift
//  Domain
//
//  Created by KimDongWoo on 10/15/25.
//

import Foundation
import RxSwift
import DomainModel

public protocol UserSettingsRepositoryProtocol {
    func searchKeywords() -> Single<[String]>
    func saveSearchKeywords(_ values: [String]) -> Completable
    
    func lookAroundSearchKeywords() -> Single<[String]>
    func saveLookAroundSearchKeywords(_ values: [String]) -> Completable
    
    func accessToken() -> Single<String>
    func saveAccessToken(_ value: String) -> Completable
    
    func refreshToken() -> Single<String>
    func saveRefreshToken(_ value: String) -> Completable
    
    func nickname() -> Single<String>
    func saveNickname(_ value: String) -> Completable
    
    func profileImage() -> Single<Data?>
    func saveProfileImage(_ value: Data?) -> Completable
    
    func userStatus() -> Single<Bool>
    func saveUserStatus(_ value: Bool) -> Completable
    
    func email() -> Single<String>
    func saveEmail(_ value: String) -> Completable
    
    func isKakaoLogin() -> Single<Bool>
    func saveIsKakaoLogin(_ value: Bool) -> Completable
    
    func identityToken() -> Single<String>
    func saveIdentityToken(_ value: String) -> Completable
    
    func kakaoTargetId() -> Single<Int64>
    func saveKakaoTargetId(_ value: Int64) -> Completable
    
    func appleAuthCode() -> Single<String>
    func saveAppleAuthCode(_ value: String) -> Completable
    
    func agreeVersion() -> Single<String>
    func saveAgreeVersion(_ value: String) -> Completable
    
    func isShowShareAlert() -> Single<Bool?>
    func setShowShareAlert(_ value: Bool?) -> Completable
    
    func clearAllUserData() -> Completable
}
