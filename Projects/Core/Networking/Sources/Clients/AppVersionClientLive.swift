import Common
import ComposableArchitecture
import Dependency
import Foundation
import Model

// MARK: - AppVersionClient Live Implementation

extension AppVersionClient: @retroactive DependencyKey {
    public static let liveValue = Self(
        latestVersion: {
            let (data, _) = try await URLSession.shared.data(from: AppInfo.iTunesLookupURL)
            let response = try JSONDecoder().decode(AppStoreLookupResponse.self, from: data)

            guard let latest = response.results.first?.version else {
                throw AppVersionError.versionNotFound
            }

            return latest
        },
        currentVersion: {
            AppInfo.currentVersion
        }
    )
}
