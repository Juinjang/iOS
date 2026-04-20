import ProjectDescription

// MARK: - DesignSystem 모듈 프로젝트 Helper

public extension Project {

    static func designSystem(
        dependencies: [TargetDependency] = []
    ) -> Project {

        Project(
            name: "DesignSystem",
            settings: .shared,
            targets: [
                .target(
                    name: "DesignSystem",
                    destinations: Environment.destinations,
                    product: Environment.moduleProduct,
                    bundleId: "com.juinjang.designsystem",
                    deploymentTargets: Environment.deploymentTarget,
                    sources: ["Sources/**"],
                    resources: ["Resources/**"],
                    dependencies: dependencies,
                    settings: .shared
                )
            ],
            schemes: [
                .scheme(
                    name: "DesignSystem",
                    buildAction: .buildAction(targets: [
                        TargetReference(stringLiteral: "DesignSystem")
                    ])
                )
            ],
            resourceSynthesizers: [
                .custom(name: "Colors", parser: .assets, extensions: ["xcassets"]),
                .custom(name: "Images", parser: .assets, extensions: ["xcassets"]),
                .fonts()
            ]
        )
    }
}
