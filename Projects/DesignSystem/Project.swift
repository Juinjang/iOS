import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.designSystem(
    dependencies: [
        .core(.common),
        .external(.lottie)
    ]
)
