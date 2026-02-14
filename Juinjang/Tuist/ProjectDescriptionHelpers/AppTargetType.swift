
import ProjectDescription

// MARK: - AppTargetType
public enum AppTargetType: String {
    case prod = "PROD"
    case dev = "DEV"
}

// MARK: - AppTargetEnvironment
public extension AppTargetType {
    var targetName: String {
        switch self {
        case .prod:
            return "Juinjang"
        case .dev:
            return "Juinjang-dev"
        }
    }
    
    var bundleID: String {
        return "com.juinjangteam.Juinjang"
    }
    
    var plistFile: InfoPlist {
        switch self {
        case .prod:
            return .file(path: .plist.appInfo)
        case .dev:
            return .file(path: .plist.appInfoDev)
        }
    }
    
    var appIconName: String {
        switch self {
        case .prod:
            return "AppIcon"
        case .dev:
            return "AppIcon-dev"
        }
    }
    
    var displayName: String {
        switch self {
        case .prod:
            return "주인장"
        case .dev:
            return "주인장-개발"
        }
    }
    
    var xcconfigPath: Path {
        switch self {
        case .prod:
            return Path.relativeToRoot("Projects/XCConfig/App/Release.xcconfig")
        case .dev:
            return Path.relativeToRoot("Projects/XCConfig/App/Debug.xcconfig")
        }
    }
    
    var baseSettings: SettingsDictionary {
        return [
            "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
            "OTHER_LDFLAGS": "-ObjC",
            "ASSETCATALOG_COMPILER_APPICON_NAME": "\(appIconName)",
            "CFBundleDisplayName": "\(displayName)",
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "\(rawValue)"
        ]
    }
    
    var baseConfigurations: [Configuration] {
        return [
            .debug(name: .debug, xcconfig: xcconfigPath),
            .release(name: .release, xcconfig: xcconfigPath)
        ]
    }
}
