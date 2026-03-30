import ComposableArchitecture
import Common
import Dependency
import Model

import Alamofire

// MARK: - APIClient Live 구현
/// Core/Dependency의 APIClient Interface를 실제 네트워크 호출로 구현
/// App 모듈에서 링크되어 런타임에 자동 주입됩니다.

extension APIClient: DependencyKey {

    public static let liveValue: Self = {
        let client = NetworkClient()

        return Self(
            fetchHomeFeed: {
                let response: ResultResponse<[Post]> = try await client.request(
                    HomeAPI.fetchFeed,
                    responseType: ResultResponse<[Post]>.self
                )
                return try APIMapper.mapData(response, transform: { $0 })
            },
            fetchUserProfile: { userId in
                let response: ResultResponse<User> = try await client.request(
                    UserAPI.fetchProfile(userId: userId),
                    responseType: ResultResponse<User>.self
                )
                return try APIMapper.mapData(response, transform: { $0 })
            }
        )
    }()
}
