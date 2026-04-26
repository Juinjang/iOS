import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    module: .setting,
    dependencies: [
        .core(.dependency),
        .core(.model)
    ]
)
