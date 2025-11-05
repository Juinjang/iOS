//
//  JuinjangAPI.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation
import Alamofire

public enum JuinjangAPI {
    case kakaoLogin(kakaoTargetId: Int64)
    case kakaoLoginCallback
    case appleLogin
    
    case signUpKakao(kakaoTargetId: Int64)
    case signUpApple
    
    case withdrawKakao(targetId: Int64)  // 카카오 탈퇴
    case withdrawApple(xAppleCode: String)  // 애플 탈퇴
    case regenerateToken
    case logout
    
    case saveNickname
    case profile
    case editProfileImage
    case updateAgreeVersion(version: String)
    
    case showChecklist(imjangId: Int)
    case saveChecklist(imjangId: Int)
    
    case fetchReportInfo(imjangId: Int)
    
    
    case scrap(imjangId: Int)
    case cancelScrap(imjangId: Int)
    case totalImjang(sort: String)
    case createImjang
    case modifyImjang(imjangId: Int)
    case searchImjang(keyword: String)
    case mainImjang
    case detailImjang(imjangId: Int)
    case deleteImjangs(imjangIds: [Int])
    
    case memo(imjangId: Int)
    case fetchRecordingRoom(imjangId: Int)
    case fetchImage(imjangId: Int)
    case addImage
    case deleteImage
    case uploadRecordFile
    case fetchRecordFiles(imjangId: Int)
    case deleteRecordFile(recordId: Int)
    case editRecordName(recordId: Int, recordName: String)
    case editRecordContent(recordId: Int, content: String)
    
    public var baseURL: String {
        guard let baseUrl = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
                fatalError("BASE_URL not found in Info.plist")
            }
        return baseUrl
    }
    
    public var endpoint: URL {
        switch self {
        case .kakaoLogin:
            return URL(string: baseURL + "auth/v2/kakao/login")!
        case .kakaoLoginCallback:
            return URL(string: baseURL + "auth/v2/kakao/callback")!
        case .appleLogin:
            return URL(string: baseURL + "auth/v2/apple/login")!
        case .signUpKakao:
            return URL(string: baseURL + "auth/v2/kakao/signup")!
        case .signUpApple:
            return URL(string: baseURL + "auth/v2/apple/signup")!
        case .withdrawKakao:
            return URL(string: baseURL + "auth/withdraw/kakao")!
        case .withdrawApple:
            return URL(string: baseURL + "auth/withdraw/apple")!
        case .regenerateToken:
            return URL(string: baseURL + "auth/regenerate-token")!
        case .logout:
            return URL(string: baseURL + "auth/logout")!
        case .saveNickname:
            return URL(string: baseURL + "nickname")!
        case .profile:
            return URL(string: baseURL + "profile")!
        case .editProfileImage:
            return URL(string: baseURL + "profile/image")!
        case .updateAgreeVersion:
            return URL(string: baseURL + "members/terms")!
            
        case .showChecklist(let imjangId),
                .saveChecklist(let imjangId):
            return URL(string: baseURL + "checklist/\(imjangId)")!
        case .fetchReportInfo(let imjangId):
            return URL(string: baseURL + "report/\(imjangId)")!
            
            
        case .scrap(let imjangId), .cancelScrap(let imjangId):
            return URL(string: baseURL + "limjangs/scraps/\(imjangId)")!
        case .totalImjang, .createImjang:
            return URL(string: baseURL + "limjang")!
        case .modifyImjang(let imjangId):
            return URL(string: baseURL + "limjang/\(imjangId)")!
            
        case .searchImjang(let keyword):
            return URL(string: baseURL + "limjang/\(keyword)")!
            
        case .mainImjang:
            return URL(string: baseURL + "limjang/v2/main")!
        case .detailImjang(let imjangId):
            return URL(string: baseURL + "limjang/detail/\(imjangId)")!
        case .deleteImjangs:
            return URL(string: baseURL + "limjang")!
        case .memo(let imjangId):
            return URL(string: baseURL + "memo/\(imjangId)")!
        case .fetchRecordingRoom(let imjangId):
            return URL(string: baseURL + "record/\(imjangId)")!
         
        case .fetchImage(let imjangId):
            return URL(string: baseURL + "limjang/image/\(imjangId)")!
        case .addImage:
            return URL(string: baseURL + "limjang/image")!
        case .deleteImage:
            return URL(string: baseURL + "limjang/image/delete")!
            
        case .uploadRecordFile:
            return URL(string: baseURL + "record")!
        case .fetchRecordFiles(let imjangId):
            return URL(string: baseURL + "record/all/\(imjangId)")!
        case .deleteRecordFile(let recordId):
            return URL(string: baseURL + "record/\(recordId)")!
        case .editRecordName(let recordId, _):
            return URL(string: baseURL + "record/title/\(recordId)")!
        case .editRecordContent(let recordId, _):
            return URL(string: baseURL + "record/content/\(recordId)")!
        }
    }
    
    public var header: HTTPHeaders {
        switch self {
        case .addImage, .uploadRecordFile:
            return [
                "Content-Type": "multipart/form-data",
                "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"
            ]
        case .kakaoLogin(let kakaoTargetId), .signUpKakao(let kakaoTargetId):
            return [
                "Content-Type": "application/json",
                "target-id": "\(kakaoTargetId)" // Int64를 문자열로 변환하여 직접 추가
            ]
        case .logout:
            return ["Content-Type": "application/json",
                    "Refresh-Token": "Bearer \(UserDefaultManager.shared.refreshToken)"]
            
        case .regenerateToken:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)",
                    "Refresh-Token": "Bearer \(UserDefaultManager.shared.refreshToken)"]
            
        case .withdrawKakao(let targetId):
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)",
                    "target-id": "\(targetId)"]
        case .withdrawApple(let xAppleCode):
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)",
                    "X-Apple-Code": xAppleCode]
            
        case .signUpApple, .appleLogin:
            return [:]
            
        default:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"]
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .saveChecklist, .scrap, .createImjang, .regenerateToken, .logout, .memo, .addImage, .deleteImage, .uploadRecordFile, .kakaoLogin, .signUpKakao, .signUpApple, .appleLogin:
            return .post
        case .showChecklist, .totalImjang, .searchImjang, .mainImjang, .detailImjang,  
                .kakaoLoginCallback, .profile, .fetchRecordingRoom, .fetchImage, .fetchRecordFiles, .fetchReportInfo:
            return .get
        case .saveNickname, .updateAgreeVersion, .modifyImjang, .editRecordName, .editRecordContent, .editProfileImage:
            return .patch
        case .deleteRecordFile, .cancelScrap, .deleteImjangs, .withdrawKakao, .withdrawApple:
            return .delete
        }
    }
    
    public var parameter: [String: Any] {
        switch self {
        case .totalImjang(let sort):
            return ["sort":sort]
        case .detailImjang(let imjangId):
            return  ["limjangIdList": imjangId]
        case .editRecordName(_, let recordName):
            return ["recordName": recordName]
        case .editRecordContent(_, let content):
            return ["recordScript": content]
        default:
            return [:]
        }
    }
}
