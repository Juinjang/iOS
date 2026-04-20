import Foundation

import Common
import Dependency
import Model

import ComposableArchitecture

// MARK: - AppVersionClient Live Implementation

extension AppVersionClient: @retroactive DependencyKey {
    public static let liveValue = Self(
        latestVersion: {
            guard let iTunesLookupURL = AppInfo.iTunesLookupURL else {
                throw AppVersionError.urlNotFound
            }
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
