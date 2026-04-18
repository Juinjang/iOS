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
        return [
            "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
            "OTHER_LDFLAGS": "-ObjC",
            "ASSETCATALOG_COMPILER_APPICON_NAME": "\(appIconName)",
            "CFBundleDisplayName": "\(displayName)",
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "\(rawValue)",
            "SWIFT_VERSION": "6.0",
            "IPHONEOS_DEPLOYMENT_TARGET": "17.0",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "SWIFT_STRICT_CONCURRENCY": "complete",
            "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
            "MARKETING_VERSION": "\(Environment.appVersion)",
            "CURRENT_PROJECT_VERSION": "\(Environment.build)",
            "ALWAYS_SEARCH_USER_PATHS": "NO"
        ]
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
