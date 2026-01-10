import ProjectDescription

let project = Project(
    name: "Juinjang",
    targets: [
        .target(
            name: "Juinjang",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.Juinjang",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "Juinjang/Sources",
                "Juinjang/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "JuinjangTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.JuinjangTests",
            infoPlist: .default,
            buildableFolders: [
                "Juinjang/Tests"
            ],
            dependencies: [.target(name: "Juinjang")]
        ),
    ]
)
