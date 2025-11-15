//
//  Project.swift
//  
//
//  Created by KimDongWoo on 8/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    moduleType: .domain,
    targets: [
        .makeTarget(
            module: .domain,
            product: .staticLibrary
        )
    ]
)
