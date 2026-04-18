import ProjectDescription

// MARK: - Core 모듈 프로젝트 Helper

public extension Project {

    static func core(
        module: ModuleType.Core,
        dependencies: [TargetDependency] = [],
        hasResources: Bool = false
    ) -> Project {

        let name = module.rawValue

        return Project(
            name: name,
            settings: .shared,
            targets: [
                .target(
                    name: name,
                    destinations: Environment.destinations,
                    product: .staticFramework,
                    bundleId: "com.juinjang.core.\(name.lowercased())",
                    deploymentTargets: .iOS("17.0"),
                    sources: ["Sources/**"],
                    resources: hasResources ? ["Resources/**"] : nil,
                    dependencies: dependencies,
                    settings: .secretShared
                )
            ],
            schemes: [
                .scheme(
                    name: name,
                    buildAction: .buildAction(targets: [
                        TargetReference(stringLiteral: name)
                    ])
                )
            ]
        )
    }
}
