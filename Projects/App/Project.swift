import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "App",
    settings: .shared,
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "com.juinjang.app",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "주인장",
                "UILaunchStoryboardName": "LaunchScreen"
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                // Feature
                .feature(.splash),
                .feature(.onboarding),
                .feature(.login),
                .feature(.home),
                // Core — Live 구현체는 App에서 링크
                .core(.network),

                // DesignSystem
                .designSystem
            ],
            settings: .shared
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
