import ProjectDescription
import ProjectDescriptionHelpers

let debugConfig = Path.relativeToRoot("Projects/XCConfig/App/Debug.xcconfig")
let releaseConfig = Path.relativeToRoot("Projects/XCConfig/App/Release.xcconfig")
let appDependencies: [Module] = [
    .core(.common),
    .spm(.alamofire),
    .spm(.amplitude),
    .spm(.dgCharts),
    .spm(.dsWaveformImage),
    .spm(.dsWaveformImageViews),
    .spm(.fsCalendar),
    .spm(.kakaoAuth),
    .spm(.kakaoShare),
    .spm(.kakaoUser),
    .spm(.kakaoCommon),
    .spm(.kingfisher),
    .spm(.lottie),
    .spm(.reactorKit),
    .spm(.realmSwift),
    .spm(.rxSwift),
    .spm(.rxCocoa),
    .spm(.rxDataSources),
    .spm(.skeletonView),
    .spm(.snapKit),
    .spm(.tabman),
    .spm(.then),
    .spm(.toast),
]

let project = Project(
    name: "juinjang",
    targets: [
        
        // MARK: - PROD
        .make(
            name: "juinjang",
            product: .app,
            bundleId: "com.juinjangteam.juinjang",
            infoPlist: .file(path: .plist.appInfo),
            sources: ["Sources/**"],
            resources: ["Resources/**", "Sources/Manager/InAppPurchase/Products.storekit"],
            entitlements: .file(path: .relativeToRoot("Projects/App/Entitlements/juinjang.entitlements")),
            dependencies: appDependencies,
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
                    "OTHER_LDFLAGS": "-ObjC",
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "CFBundleDisplayName": "주인장",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "PROD",
                    "MARKETING_VERSION": "1.2.0", // Version
                    "CURRENT_PROJECT_VERSION": "1" // Build
                ],
                configurations: [
                    .debug(name: .debug, xcconfig: releaseConfig),
                    .release(name: .release, xcconfig: releaseConfig)
                ])
        ),
        
        // MARK: - DEV
        .make(
            name: "juinjang-dev",
            product: .app,
            bundleId: "com.juinjangteam.juinjang.dev",
            infoPlist: .file(path: .plist.appInfoDev),
            sources: ["Sources/**"],
            resources: ["Resources/**", "Sources/Manager/InAppPurchase/Products.storekit"],
            entitlements: .file(path: .relativeToRoot("Projects/App/Entitlements/juinjang.entitlements")),
            dependencies: appDependencies,
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
                    "OTHER_LDFLAGS": "-ObjC",
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon-dev",
                    "CFBundleDisplayName": "주인장-개발",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEV",
                    "MARKETING_VERSION": "1.2.1", // Version
                    "CURRENT_PROJECT_VERSION": "1" // Build
                ],
                configurations: [
                    .debug(name: .debug, xcconfig: debugConfig),
                    .release(name: .release, xcconfig: debugConfig)
                ])
        )
    ],
    additionalFiles: [
        .glob(pattern: .plist.googleServiceInfoDebug),
        .folderReference(path: .config.sharedConfig)
    ]
)

public extension TargetDependency {
    static func spm(_ name: String) -> TargetDependency {
        return .external(name: name)
    }
}
