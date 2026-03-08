import Foundation

import Alamofire

public enum UserAPI {
    case fetchProfile(userId: String)
    case updateProfile(body: UpdateProfileRequest)
}

extension UserAPI: APITarget {

    public var endPoint: String {
        switch self {
        case .fetchProfile(let userId):
            return "/api/v1/users/\(userId)"
        case .updateProfile:
            return "/api/v1/users/me"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .fetchProfile:
            return .get
        case .updateProfile:
            return .put
        }
    }

    public var authorizationType: AuthorizationType {
        return .bearer
    }

    public var task: RequestTask {
        switch self {
        case .fetchProfile:
            return .requestPlain
        case .updateProfile(let body):
            return .requestBody(body)
        }
    }
}
