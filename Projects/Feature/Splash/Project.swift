import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    module: .splash,
    dependencies: [
        .core(.dependency),
        .core(.model),
        .external(.lottie)
    ]
)
