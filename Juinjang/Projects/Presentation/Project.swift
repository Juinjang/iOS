//
//  Project.swift
//  Manifests
//
//  Created by 조유진 on 2/14/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Module.presentation.name,
    targets: [
        .target(
            for: .presentation,
            product: .staticFramework,
            dependencies: [
                .module(.designSystem),
                .module(.domain),
                .SPM.ComposableArchitecture
            ]
        )
    ]
)
