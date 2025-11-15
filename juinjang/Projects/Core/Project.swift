import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    moduleType: .core,
    targets: [
        .makeTarget(
            module: .core,
            product: .staticLibrary,
            dependencies: [
                .spm(.firebaseAnalytics),
                .spm(.iqKeyboardManager)
            ]
        )
    ]
)
