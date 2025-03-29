import ProjectDescription
import ProjectDescriptionHelpers

let debugConfig = Path.relativeToRoot("Projects/XCConfig/App/Debug.xcconfig")
let releaseConfig = Path.relativeToRoot("Projects/XCConfig/App/Release.xcconfig")

let project = Project(
    name: "juinjang",
    targets: [
        .make(
            name: "juinjang",
            product: .app,
            bundleId: "com.juinjangteam.juinjang",
            infoPlist: .file(path: .plist.appInfo),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(path: .relativeToRoot("Projects/App/Entitlements/juinjang.entitlements")),
            dependencies: [
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
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
                    "OTHER_LDFLAGS": "-ObjC"
                ],
                configurations: [
                    .debug(name: .debug, xcconfig: debugConfig),
                    .release(name: .release, xcconfig: releaseConfig)
                ])
        ),
    ],
    additionalFiles: [
        .glob(pattern: .plist.googleServiceInfoDebug),
        .folderReference(path: .config.sharedConfig)
    ]
)
