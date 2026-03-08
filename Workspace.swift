import ProjectDescription

let workspace = Workspace(
    name: "Juinjang",
    projects: [
        "Projects/App",
        "Projects/Feature/**",
        "Projects/Core/**",
        "Projects/DesignSystem"
    ],
    schemes: [
        .scheme(
            name: "TMADemo-All",
            buildAction: .buildAction(targets: [
                .project(path: "Projects/App", target: "App")
            ]),
            runAction: .runAction(
                configuration: .debug,
                executable: .project(path: "Projects/App", target: "App")
            )
        )
    ]
)
