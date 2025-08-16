//
//  UserDefaultManager.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//
import Foundation
import UIKit

final class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    private init() { }
    
    enum UDKey: String, CaseIterable {
        case searchKeywords
        case lookAroundSearchKeywords
        case accessToken
        case refreshToken
        case nickname
        case userStatus
        case email
        case profileImage
        case isKakaoLogin
        case identityToken
        case isShowGuide
        case kakaoTargetId
        case appleAuthCode
        case agreeVersion
        case isShowShareAlert
        case isTesting // MARK: Temp 추후 삭제예정
        case isHttpsEnabled
    }
    
    let ud = UserDefaults.standard
    
    var searchKeywords: [String] {
        get { ud.array(forKey: UDKey.searchKeywords.rawValue) as? [String] ?? [] }
        set { ud.set(newValue, forKey: UDKey.searchKeywords.rawValue) }
    }
    
    var lookAroundSearchKeywords: [String] {
        get { ud.array(forKey: UDKey.lookAroundSearchKeywords.rawValue) as? [String] ?? [] }
        set { ud.set(newValue, forKey: UDKey.lookAroundSearchKeywords.rawValue) }
    }
    
    var accessToken: String {
        get { ud.string(forKey: UDKey.accessToken.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.accessToken.rawValue) }
    }
    
    var refreshToken: String {
        get { ud.string(forKey: UDKey.refreshToken.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.refreshToken.rawValue) }
    }
    
    var nickname: String {
        get { ud.string(forKey: UDKey.nickname.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.nickname.rawValue) }
    }
    
    var userStatus: Bool {
        get { ud.bool(forKey: UDKey.userStatus.rawValue) }
        set { ud.set(newValue, forKey: UDKey.userStatus.rawValue) }
    }
    
    var email: String {
        get { ud.string(forKey: UDKey.email.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.email.rawValue) }
    }
    
    var profileImage: UIImage? {
        get {
            if let imageData = ud.data(forKey: UDKey.profileImage.rawValue) {
                return UIImage(data: imageData)
            }
            return nil
        }
        set {
            if let image = newValue, let imageData = image.pngData() {
                ud.set(imageData, forKey: UDKey.profileImage.rawValue)
            } else {
                ud.removeObject(forKey: UDKey.profileImage.rawValue)
            }
        }
    }
    
    var isKakaoLogin: Bool {
        get { ud.bool(forKey: UDKey.isKakaoLogin.rawValue) }
        set { ud.set(newValue, forKey: UDKey.isKakaoLogin.rawValue) }
    }
    
    var identityToken: String {
        get { ud.string(forKey: UDKey.identityToken.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.identityToken.rawValue) }
    }
    
    var kakaoTargetId: Int64 {
        get { ud.object(forKey: UDKey.kakaoTargetId.rawValue) as? Int64 ?? 0 }
        set { ud.set(newValue, forKey: UDKey.kakaoTargetId.rawValue) }
    }
    
    var appleAuthCode: String {
        get { ud.string(forKey: UDKey.appleAuthCode.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.appleAuthCode.rawValue) }
    }
    
    var agreeVersion: String {
        get { ud.string(forKey: UDKey.agreeVersion.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.agreeVersion.rawValue) }
    }
    
    var isShowShareAlert: Bool? {
        get { ud.object(forKey: UDKey.isShowShareAlert.rawValue) as? Bool }
        set { ud.set(newValue, forKey: UDKey.isShowShareAlert.rawValue) }
    }
    
    // MARK: - Temp 추후 삭제 예정
    var isTesting: Bool? {
        get { ud.object(forKey: UDKey.isTesting.rawValue) as? Bool }
        set { ud.set(newValue, forKey: UDKey.isTesting.rawValue) }
    }
    
    var isHttpsEnabled: Bool? {
        get { ud.object(forKey: UDKey.isHttpsEnabled.rawValue) as? Bool }
        set { ud.set(newValue, forKey: UDKey.isHttpsEnabled.rawValue) }
    }
    
    func removeUserInfo() {
        let udKeys = UDKey.allCases
        
        for key in udKeys {
            if key == UDKey.userStatus {
                continue
            }
            UserDefaultManager.shared.clearKey(key.rawValue)
        }
    }
    
    func clearKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}

