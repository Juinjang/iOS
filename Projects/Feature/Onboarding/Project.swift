import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    module: .onboarding,
    dependencies: [
        .core(.dependency),
        .core(.model)
    ]
)
