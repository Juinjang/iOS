import Foundation

// MARK: - AppInfo
/// 앱 전역 상수 관리

public enum AppInfo {
    // MARK: - App Store
    public static let appId = "6476806621"
    public static let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)")
    
    // MARK: - Bundle
    public static var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    public static var bundleId: String {
        Bundle.main.bundleIdentifier ?? ""
    }

    // MARK: - iTunes Lookup
    public static var iTunesLookupURL: URL? {
        URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)&country=kr")
    }
}
