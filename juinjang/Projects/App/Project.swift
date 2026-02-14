import ProjectDescription
import ProjectDescriptionHelpers

let appDependencies: [Module] = [
    .core(.common),
    .data(.storage),
    .data(.network),
    .data(.repositories),
    .domain(.repositoryInterfaces),
    .domain(.services),
    .domain(.usecases),
    .domain(.usecaseInterfaces),
    .presentation(.scenes),
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
    .spm(.firebaseFirestore)
]

let project = Project(
    name: "App",
    targets: [
        // MARK: - PROD
        .makeAppTarget(
            appType: .prod,
            appDependencies: appDependencies,
            appVersion: "2.0.9",
            build: "2025.02.14.1"
        ),
        
        // MARK: - DEV
        .makeAppTarget(
            appType: .dev,
            appDependencies: appDependencies,
            appVersion: "2.0.9",
            build: "2025.02.14.1"
        )
    ],
    additionalFiles: [
        .glob(pattern: .plist.googleServiceInfoDebug),
        .folderReference(path: .config.sharedConfig)
    ]
)
