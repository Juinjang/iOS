import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Core",
    targets: [
        .make(
            name: "Common",
            product: .staticLibrary,
            productName: "Core.Common",
            bundleId: "com.juinjangteam.juinjang.core.common",
            sources: ["Common/**"],
            dependencies: [
                .spm(.firebaseAnalytics),
                .spm(.iqKeyboardManager)
            ]
        ),
        .make(
            name: "Network",
            product: .staticLibrary,
            productName: "Core.Network",
            bundleId: "com.juinjangteam.juinjang.core.network",
            sources: ["Network/**"],
            dependencies: []
        ),
        .make(
            name: "Logging",
            product: .staticLibrary,
            productName: "Core.Logging",
            bundleId: "com.juinjangteam.juinjang.core.logging",
            sources: ["Logging/**"],
            dependencies: []
        ),
    ]
)
