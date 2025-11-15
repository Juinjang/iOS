//
//  Project.swift
//  
//
//  Created by KimDongWoo on 8/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    moduleType: .presentation,
    targets: [
        .makeTarget(
            module: .presentation,
            product: .staticLibrary,
            dependencies: [
                .domain,
                .designSystem
            ]
        )
    ]
)
