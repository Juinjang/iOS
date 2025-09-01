//
//  Project.swift
//  
//
//  Created by KimDongWoo on 8/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    moduleType: .designSystem,
    targets: [
        .makeTarget(
            module: .designSystem(.resources),
            product: .staticLibrary
        ),
        .makeTarget(
            module: .designSystem(.components),
            product: .staticLibrary,
            dependencies: [
                .designSystem(.resources)
            ]
        ),
    ]
)
