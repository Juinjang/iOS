// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings
    import ProjectDescriptionHelpers

    let packageSettings: PackageSettings = .init(
        productTypes: [:]
    )
#endif

let package = Package(
    name: "Juinjang",
    dependencies: []
)
