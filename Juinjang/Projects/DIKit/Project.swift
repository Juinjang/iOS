//
//  Project.swift
//  Manifests
//
//  Created by 조유진 on 2/14/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Module.diKit.name,
    targets: [
        .target(
            for: .diKit,
            product: .framework
        )
    ]
)
