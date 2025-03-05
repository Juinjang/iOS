import ProjectDescription
import ProjectDescriptionHelpers

let debugConfig = Path.relativeToRoot("Projects/App/XCConfig/Debug.xcconfig")
let releaseConfig = Path.relativeToRoot("Projects/App/XCConfig/Release.xcconfig")

let project = Project(
    name: "juinjang",
    targets: [
        .make(
            name: "juinjang",
            product: .app,
            infoPlist: .extendingDefault(with: [
                "UILaunchStoryboardName": .string("LaunchScreen"),
                "ITSAppUsesNonExemptEncryption": .boolean(false),
                "LSApplicationQueriesSchemes": .array(["kakaokompassauth", "kakaolink"]),
                "BASE_URL": .string("$(BASE_URL)"),
                "CFBundleVersion": .string("$(CURRENT_PROJECT_VERSION)"),
                "UIUserInterfaceStyle": .string("Light"),
                "UIApplicationSupportsIndirectInputEvents": .boolean(true),
                "CFBundlePackageType": .string("$(PRODUCT_BUNDLE_PACKAGE_TYPE)"),
                "NSAppTransportSecurity": .dictionary(["NSAllowsArbitraryLoads" : .boolean(true)]),
                "UIAppFonts": .array([
                    "Pretendard-Black.otf",
                    "Pretendard-ExtraBold.otf",
                    "Pretendard-Bold.otf",
                    "Pretendard-SemiBold.otf",
                    "Pretendard-Medium.otf",
                    "Pretendard-Regular.otf",
                    "Pretendard-Light.otf",
                    "Pretendard-ExtraLight.otf",
                    "Pretendard-Thin.otf",
                    "omyu pretty.ttf"
                ]),
                "CFBundleDisplayName": .string("주인장"),
                "NSMicrophoneUsageDescription": .string("마이크 접근 권한을 허용하는 경우에만 녹음을 통한 노트 생성 및 음성 인식 서비스 이용이 가능합니다. (필수 권한)"),
                "NSCameraUsageDescription": .string("임장 활동에 대한 사진 촬영을 위해 카메라 접근 권한이 필요합니다."),
                "NSPhotoLibraryAddUsageDescription": .string("임장 활동에 대한 사진 업로드를 위해 사진 앨범에 접근하려면 허용이 필요합니다."),
                "NSSpeechRecognitionUsageDescription": .string("임장 활동에 대한 녹음을 텍스트로 변환하기 위해 음성 인식 권한이 필요합니다."),
            ]),
            entitlements: .file(path: .relativeToRoot("Projects/App/Entitlements/juinjang.entitlements")),
            dependencies: [
                .spm(.alamofire),
                .spm(.amplitude),
                .spm(.dgCharts),
                .spm(.dsWaveformImage),
                .spm(.dsWaveformImageViews),
                .spm(.firebaseAnalytics),
                .spm(.fsCalendar),
                .spm(.iqKeyboardManager),
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
                .spm(.skeletonView),
                .spm(.snapKit),
                .spm(.tabman),
                .spm(.then),
                .spm(.toast),
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"
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
