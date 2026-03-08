import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.core(
    module: .dependency,
    dependencies: [
        .core(.model),
        .tca
    ]
)
