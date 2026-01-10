
import ProjectDescription
import ProjectDescriptionHelpers

let appDependencies: [TargetDependency] = [
    .SPM.Alamofire,
    .SPM.Reachability,
    .SPM.SnapKit
]

let project = Project(
    name: Module.app.name,
    packages: [
        .SPM.Alamofire,
        .SPM.Reachability,
        .SPM.SnapKit
    ],
    targets: [
        // MARK: - PROD
        .appTarget(
            appType: .prod,
            appDependencies: appDependencies
        ),
        
        // MARK: - DEV
        .appTarget(
            appType: .dev,
            appDependencies: appDependencies
        )
    ],
    additionalFiles: [
        .glob(pattern: .config.sharedConfig)
    ]
)
