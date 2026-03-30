import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    module: .login,
    dependencies: [
        .core(.dependency),
        .core(.model)
    ]
)
