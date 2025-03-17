import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Core",
    targets: [
        .make(
            name: "Common",
            product: .staticLibrary,
            bundleId: "com.juinjangteam.juinjang.common",
            sources: ["Common/**"],
            dependencies: [
                .spm(.firebaseAnalytics),
                .spm(.iqKeyboardManager)
            ]
        ),
    ]
)
