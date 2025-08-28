import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Core",
    targets: [
        .make(
            name: "Common",
            product: .staticLibrary,
            productName: "CoreCommon",
            bundleId: "com.juinjangteam.juinjang.core.common",
            sources: ["Common/**"],
            dependencies: [
                .spm(.firebaseAnalytics),
                .spm(.iqKeyboardManager)
            ]
        )
    ]
)
