import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    moduleType: .core,
    targets: [
        .makeTarget(
            module: .core(.common),
            product: .staticLibrary,
            dependencies: [
                .spm(.firebaseAnalytics),
                .spm(.iqKeyboardManager)
            ]
        )
    ]
)
