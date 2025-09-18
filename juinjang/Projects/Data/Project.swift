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
            module: .data(.model),
            product: .staticLibrary,
            dependencies: [
                .domain(.model)
            ]
        ),
        .makeTarget(
            module: .data(.storage),
            product: .staticFramework,
            dependencies: [
                .data(.model)
            ]
        ),
        .makeTarget(
            module: .data(.network),
            product: .staticLibrary,
            dependencies: [
                .data(.storage),
                .data(.model)
            ]
        ),
        .makeTarget(
            module: .data(.repositories),
            product: .staticLibrary,
            dependencies: [
                .data(.model),
                .data(.storage),
                .data(.network),
                .domain(.repositoryInterfaces)
            ]
        )
    ]
)
