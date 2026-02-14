//
//  Project.swift
//  Manifests
//
//  Created by 조유진 on 2/14/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Module.designSystem.name,
    targets: [
        .target(
            for: .designSystem,
            product: .framework,
            resources: .resources,
            dependencies: [
                .module(.core)
            ]
        )
    ],
    resourceSynthesizers: [
        .custom(name: "Colors", parser: .assets, extensions: ["xcassets"]),
        .custom(name: "Images", parser: .assets, extensions: ["xcassets"]),
        .fonts()
    ]
)
