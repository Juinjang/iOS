import Foundation

import Common
import Dependency
import Model

import ComposableArchitecture

// MARK: - AppVersionClient Live Implementation

extension AppVersionClient: @retroactive DependencyKey {
    public static let liveValue = AppVersionClient(
        latestVersion: {
            guard let iTunesLookupURL = AppInfo.iTunesLookupURL else { return "1.0.0" }
            let (data, _) = try await URLSession.shared.data(from: iTunesLookupURL)
            let response = try JSONDecoder().decode(AppStoreLookupResponse.self, from: data)

            guard let latestVersion = response.results.first?.version else {
                throw AppVersionError.versionNotFound
            }

            return latestVersion
        },
        currentVersion: {
            AppInfo.currentVersion
        }
    )
}
