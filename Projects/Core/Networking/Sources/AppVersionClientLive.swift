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
            let bundleId = Bundle.main.bundleIdentifier ?? ""
            guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)&country=kr") else {
                throw AppVersionError.versionNotFound
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AppStoreLookupResponse.self, from: data)

            guard let latest = response.results.first?.version else {
                throw AppVersionError.versionNotFound
            }

            let current = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
            let result = current.compare(latest, options: .numeric) == .orderedAscending
            print("🔍 AppVersion - current: \(current), latest: \(latest), needsUpdate: \(result)")
            return result
        }
    )
}
