// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "Alamofire": .framework,
            "ComposableArchitecture": .framework,

            // TCA 하위 의존성 — 전부 dynamic으로 맞춰야 Preview 동작
            "CasePaths": .framework,
            "CombineSchedulers": .framework,
            "ConcurrencyExtras": .framework,
            "CustomDump": .framework,
            "Dependencies": .framework,
            "DependenciesMacros": .framework,
            "IdentifiedCollections": .framework,
            "Perception": .framework,
            "Sharing": .framework,
            "SwiftNavigation": .framework,
            "Clocks": .framework,
            "XCTestDynamicOverlay": .framework,
            "OrderedCollections": .framework
        ]
    )
#endif

let package = Package(
    name: "Juinjang",
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.24.1"
        ),
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            from: "5.11.1"
        )
    ]
)
