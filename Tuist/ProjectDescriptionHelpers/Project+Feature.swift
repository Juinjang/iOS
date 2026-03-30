import ProjectDescription

// MARK: - Feature 모듈 프로젝트 Helper
/// Main + Testing + Tests 3계층 타깃을 자동 생성합니다.

public extension Project {

    static func feature(
        module: ModuleType.Feature,
        dependencies: [TargetDependency],
        hasResources: Bool = false,
        includeExample: Bool = true
    ) -> Project {

        let name = module.rawValue

        // 모든 Feature 공통 기본 의존성
        let baseDependencies: [TargetDependency] = [
            .external(.composableArchitecture),
            .designSystem
        ]

        let allDependencies = baseDependencies + dependencies

        var targets: [Target] = [
            // MARK: - 메인 타깃
            .target(
                name: name,
                destinations: .iOS,
                product: .staticFramework,
                bundleId: "com.juinjang.feature.\(name.lowercased())",
                deploymentTargets: .iOS("17.0"),
                sources: ["Sources/**"],
                resources: hasResources ? ["Resources/**"] : nil,
                dependencies: allDependencies,
                settings: .shared
            ),

            // MARK: - Testing 타깃 (Mock, Stub)
            .target(
                name: "\(name)Testing",
                destinations: .iOS,
                product: .staticFramework,
                bundleId: "com.juinjang.feature.\(name.lowercased()).testing",
                deploymentTargets: .iOS("17.0"),
                sources: ["Testing/**"],
                dependencies: [
                    .target(name: name)
                ],
                settings: .shared
            ),

            // MARK: - 테스트 타깃
            .target(
                name: "\(name)Tests",
                destinations: .iOS,
                product: .unitTests,
                bundleId: "com.juinjang.feature.\(name.lowercased()).tests",
                deploymentTargets: .iOS("17.0"),
                sources: ["Tests/**"],
                dependencies: [
                    .target(name: name),
                    .target(name: "\(name)Testing")
                ],
                settings: .shared
            )
        ]
        
        if includeExample {
            targets.append(
                .target(
                    name: "\(name)Example",
                    destinations: .iOS,
                    product: .app,
                    bundleId: "com.juinjang.feature.\(name.lowercased()).example",
                    deploymentTargets: .iOS("17.0"),
                    infoPlist: .extendingDefault(with: [
                        "CFBundleDisplayName": "\(name) Example",
                        "UILaunchStoryboardName": "LaunchScreen"
                    ]),
                    sources: ["Example/Sources/**"],
                    dependencies: [
                        .target(name: name),
                        .target(name: "\(name)Testing"),
                        .external(.composableArchitecture)
                    ],
                    settings: .shared
                )
            )
        }
        
        var schemes: [Scheme] = [
            // Feature 빌드 + 테스트 Scheme
            .scheme(
                name: name,
                buildAction: .buildAction(targets: [
                    TargetReference(stringLiteral: name)
                ]),
                testAction: TestAction.targets(
                    [TestableTarget(stringLiteral: "\(name)Tests")]
                )
            )
        ]

        // Example 앱 실행 Scheme
        if includeExample {
            schemes.append(
                .scheme(
                    name: "\(name)Example",
                    buildAction: .buildAction(targets: [
                        TargetReference(stringLiteral: "\(name)Example")
                    ]),
                    runAction: .runAction(
                        configuration: .debug,
                        executable: .target("\(name)Example")
                    )
                )
            )
        }

        return Project(
            name: name,
            settings: .shared,
            targets: targets,
            schemes: schemes
        )
    }
}
