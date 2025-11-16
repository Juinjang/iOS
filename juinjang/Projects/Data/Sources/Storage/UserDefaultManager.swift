//
//  UserDefaultManager.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import Foundation
import UIKit

public final class UserDefaultManager {
    public static let shared = UserDefaultManager()
    
    public init() { }
    
    private enum UDKey: String, CaseIterable {
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
    
    private let ud = UserDefaults.standard
    
    public var searchKeywords: [String] {
        get { ud.array(forKey: UDKey.searchKeywords.rawValue) as? [String] ?? [] }
        set { ud.set(newValue, forKey: UDKey.searchKeywords.rawValue) }
    }
    
    public var lookAroundSearchKeywords: [String] {
        get { ud.array(forKey: UDKey.lookAroundSearchKeywords.rawValue) as? [String] ?? [] }
        set { ud.set(newValue, forKey: UDKey.lookAroundSearchKeywords.rawValue) }
    }
    
    public var accessToken: String {
        get { ud.string(forKey: UDKey.accessToken.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.accessToken.rawValue) }
    }
    
    public var refreshToken: String {
        get { ud.string(forKey: UDKey.refreshToken.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.refreshToken.rawValue) }
    }
    
    public var nickname: String {
        get { ud.string(forKey: UDKey.nickname.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.nickname.rawValue) }
    }
    
    public var userStatus: Bool {
        get { ud.bool(forKey: UDKey.userStatus.rawValue) }
        set { ud.set(newValue, forKey: UDKey.userStatus.rawValue) }
    }
    
    public var email: String {
        get { ud.string(forKey: UDKey.email.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.email.rawValue) }
    }
    
    public var profileImage: Data? {
        get { ud.data(forKey: UDKey.profileImage.rawValue) }
        set { ud.set(newValue, forKey: UDKey.profileImage.rawValue) }
    }
    
    public var isKakaoLogin: Bool {
        get { ud.bool(forKey: UDKey.isKakaoLogin.rawValue) }
        set { ud.set(newValue, forKey: UDKey.isKakaoLogin.rawValue) }
    }
    
    public var identityToken: String {
        get { ud.string(forKey: UDKey.identityToken.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.identityToken.rawValue) }
    }
    
    public var kakaoTargetId: Int64 {
        get { ud.object(forKey: UDKey.kakaoTargetId.rawValue) as? Int64 ?? 0 }
        set { ud.set(newValue, forKey: UDKey.kakaoTargetId.rawValue) }
    }
    
    public var appleAuthCode: String {
        get { ud.string(forKey: UDKey.appleAuthCode.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.appleAuthCode.rawValue) }
    }
    
    public var agreeVersion: String {
        get { ud.string(forKey: UDKey.agreeVersion.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.agreeVersion.rawValue) }
    }
    
    public var isShowShareAlert: Bool? {
        get { ud.object(forKey: UDKey.isShowShareAlert.rawValue) as? Bool }
        set { ud.set(newValue, forKey: UDKey.isShowShareAlert.rawValue) }
    }
    
    public func removeUserInfo() {
        let udKeys = UDKey.allCases
        
        for key in udKeys {
            if key == UDKey.userStatus {
                continue
            }
            UserDefaultManager.shared.clearKey(key.rawValue)
        }
    }
    
    public func clearKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}

