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
            module: .domain(.model),
            product: .staticLibrary
        ),
        .makeTarget(
            module: .domain(.repositoryInterfaces),
            product: .staticLibrary,
            dependencies: [
                .domain(.model)
            ]
        ),
        .makeTarget(
            module: .domain(.services),
            product: .staticLibrary,
            dependencies: [
                .domain(.model)
            ]
        ),
        .makeTarget(
            module: .domain(.usecases),
            product: .staticLibrary,
            dependencies: [
                .domain(.model),
                .domain(.usecaseInterfaces),
                .domain(.services),
                .domain(.repositoryInterfaces)
            ]
        ),
        .makeTarget(
            module: .domain(.usecaseInterfaces),
            product: .staticLibrary,
            dependencies: [
                .domain(.model)
            ]
        )
    ]
)
