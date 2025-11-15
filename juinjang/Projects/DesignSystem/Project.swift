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
            module: .designSystem,
            product: .staticLibrary,
            resources: "Resources/**"
        )
    ]
)
