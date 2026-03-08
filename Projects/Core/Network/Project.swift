import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.core(
    module: .network,
    dependencies: [
        .core(.dependency),
        .core(.model),
        .core(.common)
    ]
)
