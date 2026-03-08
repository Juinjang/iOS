import Foundation

import Common

import Alamofire

// MARK: - 네트워크 인터셉터
/// Bearer 토큰을 자동으로 헤더에 추가합니다.

final class NetworkInterceptor: RequestInterceptor {

    private let tokenStorage: KeyValueStorage
    private let authType: AuthorizationType

    init(
        tokenStorage: KeyValueStorage,
        authType: AuthorizationType
    ) {
        self.tokenStorage = tokenStorage
        self.authType = authType
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        var request = urlRequest

        if authType == .bearer,
           let accessToken = tokenStorage.get(String.self, for: .accessToken) {
            request.addValue(
                "Bearer \(accessToken)",
                forHTTPHeaderField: "Authorization"
            )
        }

        completion(.success(request))
    }
}
