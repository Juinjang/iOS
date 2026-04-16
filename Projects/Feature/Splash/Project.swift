import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    module: .splash,
    dependencies: [
        .core(.common),
        .core(.dependency),
        .core(.model),
        .external(.lottie)
    ]
)
