import ProjectDescription
import ProjectDescriptionHelpers

let appDependencies: [Module] = [
    .core,
    .data,
    .domain,
    .presentation,
    .spm(.amplitude),
    .spm(.kakaoAuth),
    .spm(.kakaoShare),
    .spm(.kakaoUser),
    .spm(.kakaoCommon),
    .spm(.then),
    .spm(.firebaseFirestore)
]

let project = Project(
    name: "App",
    targets: [
        // MARK: - PROD
        .makeAppTarget(
            appType: .prod,
            appDependencies: appDependencies,
            appVersion: "2.0.5",
            build: "2025.09.10.1"
        ),
        
        // MARK: - DEV
        .makeAppTarget(
            appType: .dev,
            appDependencies: appDependencies,
            appVersion: "2.0.5",
            build: "2025.09.10.1"
        )
    ],
    additionalFiles: [
        .glob(pattern: .plist.googleServiceInfoDebug),
        .folderReference(path: .config.sharedConfig)
    ]
)
