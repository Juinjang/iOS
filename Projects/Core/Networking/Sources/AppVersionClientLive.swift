import Common
import ComposableArchitecture
import Dependency
import Foundation
import Model

// MARK: - AppVersionClient Live Implementation
/// iTunes Lookup API를 통해 App Store 최신 버전을 조회하고
/// 현재 앱 버전과 비교하여 업데이트 필요 여부를 반환

extension AppVersionClient: @retroactive DependencyKey {
    public static let liveValue = Self(
        checkNeedsUpdate: {
            let (data, _) = try await URLSession.shared.data(from: AppInfo.iTunesLookupURL)
            let response = try JSONDecoder().decode(AppStoreLookupResponse.self, from: data)

            guard let latest = response.results.first?.version else {
                throw AppVersionError.versionNotFound
            }

            let current = AppInfo.currentVersion
            return current.compare(latest, options: .numeric) == .orderedAscending
        }
    )
}
