import Foundation
import Alamofire
import Core

public enum JuinjangAPI: TargetType {
    case kakaoLogin(kakaoTargetId: Int64)
    case kakaoLoginCallback
    case appleLogin

    case signUpKakao(kakaoTargetId: Int64)
    case signUpApple

    case withdrawKakao(targetId: Int64)
    case withdrawApple(xAppleCode: String)
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
}

// MARK: - TargetType

public extension JuinjangAPI {
    var path: String {
        switch self {
        case .kakaoLogin:
            return "auth/v2/kakao/login"
        case .kakaoLoginCallback:
            return "auth/v2/kakao/callback"
        case .appleLogin:
            return "auth/v2/apple/login"
        case .signUpKakao:
            return "auth/v2/kakao/signup"
        case .signUpApple:
            return "auth/v2/apple/signup"
        case .withdrawKakao:
            return "auth/withdraw/kakao"
        case .withdrawApple:
            return "auth/withdraw/apple"
        case .regenerateToken:
            return "auth/regenerate-token"
        case .logout:
            return "auth/logout"
        case .saveNickname:
            return "nickname"
        case .profile:
            return "profile"
        case .editProfileImage:
            return "profile/image"
        case .updateAgreeVersion:
            return "members/terms"

        case .showChecklist(let imjangId),
             .saveChecklist(let imjangId):
            return "checklist/\(imjangId)"

        case .fetchReportInfo(let imjangId):
            return "report/\(imjangId)"

        case .scrap(let imjangId),
             .cancelScrap(let imjangId):
            return "limjangs/scraps/\(imjangId)"

        case .totalImjang, .createImjang:
            return "limjang"

        case .modifyImjang(let imjangId):
            return "limjang/\(imjangId)"

        case .searchImjang(let keyword):
            return "limjang/\(keyword)"

        case .mainImjang:
            return "limjang/v2/main"

        case .detailImjang(let imjangId):
            return "limjang/detail/\(imjangId)"

        case .deleteImjangs:
            return "limjang"

        case .memo(let imjangId):
            return "memo/\(imjangId)"

        case .fetchRecordingRoom(let imjangId):
            return "record/\(imjangId)"

        case .fetchImage(let imjangId):
            return "limjang/image/\(imjangId)"

        case .addImage:
            return "limjang/image"

        case .deleteImage:
            return "limjang/image/delete"

        case .uploadRecordFile:
            return "record"

        case .fetchRecordFiles(let imjangId):
            return "record/all/\(imjangId)"

        case .deleteRecordFile(let recordId):
            return "record/\(recordId)"

        case .editRecordName(let recordId, _):
            return "record/title/\(recordId)"

        case .editRecordContent(let recordId, _):
            return "record/content/\(recordId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .saveChecklist, .scrap, .createImjang, .regenerateToken,
             .logout, .memo, .addImage, .deleteImage, .uploadRecordFile,
             .kakaoLogin, .signUpKakao, .signUpApple, .appleLogin:
            return .post

        case .showChecklist, .totalImjang, .searchImjang, .mainImjang,
             .detailImjang, .kakaoLoginCallback, .profile,
             .fetchRecordingRoom, .fetchImage, .fetchRecordFiles,
             .fetchReportInfo:
            return .get

        case .saveNickname, .updateAgreeVersion, .modifyImjang,
             .editRecordName, .editRecordContent, .editProfileImage:
            return .patch

        case .deleteRecordFile, .cancelScrap, .deleteImjangs,
             .withdrawKakao, .withdrawApple:
            return .delete
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .addImage, .uploadRecordFile:
            return [
                "Content-Type": "multipart/form-data",
                "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"
            ]
        case .kakaoLogin(let kakaoTargetId),
             .signUpKakao(let kakaoTargetId):
            return [
                "Content-Type": "application/json",
                "target-id": "\(kakaoTargetId)"
            ]
        case .logout:
            return [
                "Content-Type": "application/json",
                "Refresh-Token": "Bearer \(UserDefaultManager.shared.refreshToken)"
            ]
        case .regenerateToken:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)",
                "Refresh-Token": "Bearer \(UserDefaultManager.shared.refreshToken)"
            ]
        case .withdrawKakao(let targetId):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)",
                "target-id": "\(targetId)"
            ]
        case .withdrawApple(let xAppleCode):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)",
                "X-Apple-Code": xAppleCode
            ]
        case .signUpApple, .appleLogin:
            return [:]
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"
            ]
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .totalImjang(let sort):
            return ["sort": sort]
        case .detailImjang(let imjangId):
            return ["limjangIdList": imjangId]
        case .editRecordName(_, let recordName):
            return ["recordName": recordName]
        case .editRecordContent(_, let content):
            return ["recordScript": content]
        default:
            return [:]
        }
    }
}
