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
            module: .domain(.repositoryInterfaces),
            product: .staticLibrary
        ),
        .makeTarget(
            module: .domain(.services),
            product: .staticLibrary
        ),
        .makeTarget(
            module: .domain(.usecases),
            product: .staticLibrary,
            dependencies: [
                .domain(.usecaseInterfaces),
                .domain(.services),
                .domain(.repositoryInterfaces)
            ]
        ),
        .makeTarget(
            module: .domain(.usecaseInterfaces),
            product: .staticLibrary
        )
    ]
)
