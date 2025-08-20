//
//  Project.swift
//  
//
//  Created by KimDongWoo on 8/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Domain",
    targets: [
        .make(
            name: "RepositoryInterface",
            product: .staticLibrary,
            productName: "Domain.RepositoryInterface",
            bundleId: "com.juinjangteam.juinjang.domain.repositoryinterface",
            sources: ["RepositoryInterface/**"]
        ),
        .make(
            name: "Usecase",
            product: .staticLibrary,
            productName: "Domain.Usecase",
            bundleId: "com.juinjangteam.juinjang.domain.usecase",
            sources: ["Usecase/**"],
            dependencies: [
                .domain(.usecaseInterface)
            ]
        ),
        .make(
            name: "UsecaseInterface",
            product: .staticLibrary,
            productName: "Domain.UsecaseInterface",
            bundleId: "com.juinjangteam.juinjang.domain.usecaseinterface",
            sources: ["UsecaseInterface/**"]
        )
    ]
)
