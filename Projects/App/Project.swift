import ProjectDescription
import ProjectDescriptionHelpers

let dependencies: [TargetDependency] = [
    // Feature
    .feature(.splash),
    .feature(.onboarding),
    .feature(.login),
    .feature(.home),
    .feature(.setting),
    // Core — Live 구현체는 App에서 링크
    .core(.networking),

    // DesignSystem
    .designSystem
]

let project = Project(
    name: "App",
    settings: .shared,
    targets: [
        .makeAppTarget(
            appType: .prod,
            appDependencies: dependencies
        ),
        .makeAppTarget(
            appType: .dev,
            appDependencies: dependencies
        )
    ],
    schemes: [
        .scheme(
            name: "App",
            buildAction: .buildAction(targets: [
                TargetReference(stringLiteral: "App")
            ]),
            runAction: .runAction(configuration: .debug)
        )
    ]
)
