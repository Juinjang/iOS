import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    module: .home,
    dependencies: [
        .core(.dependency),
        .core(.model)
    ]
)
