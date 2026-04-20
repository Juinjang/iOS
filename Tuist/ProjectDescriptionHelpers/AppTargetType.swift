//
//  AppTargetType.swift
//  Manifests
//
//  Created by 조유진 on 3/11/26.
//

import ProjectDescription

public enum AppTargetType: String {
    case prod = "PROD"
    case dev = "DEV"
    
    var targetName: String {
        switch self {
        case .prod:
            return "juinjang"
        case .dev:
            return "juinjang-dev"
        }
    }
    
    var bundleID: String {
        return "com.juinjangteam.juinjang"
    }
    
    var appIconName: String {
        switch self {
        case .prod:
            return "AppIcon"
        case .dev:
            return "AppIcon-Dev"
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
            return Path.relativeToRoot("Projects/XCConfig/Release.xcconfig")
        case .dev:
            return Path.relativeToRoot("Projects/XCConfig/Debug.xcconfig")
        }
    }
    
    var baseSettings: SettingsDictionary {
        var settings = Settings.baseSettings
        settings["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS"] = "YES"
        settings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "\(appIconName)"
        settings["CFBundleDisplayName"] = "\(displayName)"
        settings["SWIFT_ACTIVE_COMPILATION_CONDITIONS"] = "\(rawValue)"
        settings["MARKETING_VERSION"] = "\(Environment.appVersion)"
        settings["CURRENT_PROJECT_VERSION"] = "\(Environment.build)"
        return settings
     }
    
    var baseConfigurations: [Configuration] {
        return [
            .debug(
                name: "Debug",
                settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone"
                ],
                xcconfig: xcconfigPath
            ),
            .release(
                name: "Release",
                settings: [
                    "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule"
                ],
                xcconfig: xcconfigPath
            )
        ]
    }
}
