//
//  Project.swift
//  Manifests
//
//  Created by 조유진 on 2/14/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Module.domain.name,
    targets: [
        .target(
            for: .domain,
            product: .framework,
            dependencies: [
                .module(.core),
                .module(.diKit)
            ]
        )
    ]
)
