import ComposableArchitecture
import Common
import Dependency

// MARK: - TokenClient Live 구현

extension TokenClient: DependencyKey {

    public static let liveValue: Self = {
        let storage = UserDefaultsStorage()

        return Self(
            getAccessToken: {
                storage.get(String.self, for: .accessToken)
            },
            getRefreshToken: {
                storage.get(String.self, for: .refreshToken)
            },
            saveAccessToken: { token in
                storage.set(token, for: .accessToken)
            },
            saveRefreshToken: { token in
                storage.set(token, for: .refreshToken)
            },
            clearTokens: {
                storage.remove(for: .accessToken)
                storage.remove(for: .refreshToken)
            }
        )
    }()
}
