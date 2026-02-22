// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings
    import ProjectDescriptionHelpers

    let packageSettings: PackageSettings = .init(
        productTypes: [
            "Alamofire": .staticFramework,
            "Reachability": .staticFramework
        ]
    )
#endif

let package = Package(
    name: "Juinjang",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.11.0"),
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.0.0")
    ]
)
