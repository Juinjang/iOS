//
//  Project.swift
//  
//
//  Created by KimDongWoo on 8/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    moduleType: .data,
    targets: [
        .makeTarget(
            module: .data(.storage),
            product: .staticLibrary
        ),
        .makeTarget(
            module: .data(.network),
            product: .staticLibrary
        ),
        .makeTarget(
            module: .data(.repositories),
            product: .staticLibrary,
            dependencies: [
                .data(.storage),
                .domain(.repositoryInterfaces)
            ]
        )
    ]
)
