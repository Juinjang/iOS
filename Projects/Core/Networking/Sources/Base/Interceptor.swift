import Foundation

import Common

import Alamofire
import ComposableArchitecture

// MARK: - 네트워크 인터셉터
/// Bearer 토큰을 자동으로 헤더에 추가합니다.

final class NetworkInterceptor: RequestInterceptor {

    private let authType: AuthorizationType

    init(authType: AuthorizationType) {
        self.authType = authType
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        var request = urlRequest

        if authType == .bearer {
            @Dependency(\.userDefaultsClient) var userDefaultsClient

            if let accessToken = try? userDefaultsClient.string(.accessToken) {
                request.addValue(
                    "Bearer \(accessToken)",
                    forHTTPHeaderField: "Authorization"
                )
            }
        }

        completion(.success(request))
    }
}
