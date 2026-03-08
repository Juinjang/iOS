import ComposableArchitecture
import Dependency
import Model

// MARK: - API Client Live 구현
/// App 모듈에서 링크되어 런타임에 자동 주입됩니다.

extension APIClient: DependencyKey {

    public static let liveValue = Self(
        fetchHomeFeed: {
            let url = URL(string: "https://api.example.com/feed")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Post].self, from: data)
        },
        fetchUserProfile: { userId in
            let url = URL(string: "https://api.example.com/users/\(userId)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(User.self, from: data)
        }
    )
}
