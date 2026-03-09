import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.core(
    module: .networking,
    dependencies: [
        .core(.dependency),
        .core(.model),
        .core(.common),
        .external(.alamofire)
    ]
)
