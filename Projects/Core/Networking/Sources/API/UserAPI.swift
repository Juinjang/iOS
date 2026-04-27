import Foundation

import Alamofire

public enum UserAPI {
    case fetchProfile(userId: String)
    case updateProfile(body: UpdateProfileRequest)

    case getMyProfile
    case patchNickname(UpdateNicknameRequest)
    case patchIntroduction(UpdateIntroductionRequest)
    case patchProfileImage
    case logout
}

extension UserAPI: APITarget {

    public var endPoint: String {
        switch self {
        case .fetchProfile(let userId):
            return "/api/v1/users/\(userId)"
        case .updateProfile:
            return "/api/v1/users/me"
        case .getMyProfile:
            return "/profile"
        case .patchNickname:
            return "/nickname"
        case .patchIntroduction:
            return "/profile/introduction"
        case .patchProfileImage:
            return "/profile/image"
        case .logout:
            return "/auth/logout"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .fetchProfile, .getMyProfile:
            return .get
        case .updateProfile, .patchNickname, .patchIntroduction, .patchProfileImage:
            return .patch
        case .logout:
            return .post
        }
    }

    public var authorizationType: AuthorizationType {
        return .bearer
    }

    public var task: RequestTask {
        switch self {
        case .fetchProfile, .getMyProfile, .logout, .patchProfileImage:
            return .requestPlain
        case .updateProfile(let body):
            return .requestBody(body)
        case .patchNickname(let body):
            return .requestBody(body)
        case .patchIntroduction(let body):
            return .requestBody(body)
        }
    }
}
