import Foundation

import Alamofire

public enum HomeAPI {
    case fetchFeed
    case fetchDetail(postId: String)
}

extension HomeAPI: APITarget {

    public var endPoint: String {
        switch self {
        case .fetchFeed:
            return "/api/v1/feed"
        case .fetchDetail(let postId):
            return "/api/v1/feed/\(postId)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .fetchFeed, .fetchDetail:
            return .get
        }
    }

    public var authorizationType: AuthorizationType {
        return .bearer
    }

    public var task: RequestTask {
        switch self {
        case .fetchFeed, .fetchDetail:
            return .requestPlain
        }
    }
}
