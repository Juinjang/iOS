import Foundation

// MARK: - 공통 상수

public enum AppConstants {
    public static let appName = "TMADemo"
    public static let baseURL = "https://api.example.com"
}

// MARK: - Date Extension

extension Date {
    public var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.localizedString(for: self, relativeTo: .now)
    }
}
