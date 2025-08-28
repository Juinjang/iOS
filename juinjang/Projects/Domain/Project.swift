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
            name: "RepositoryInterfaces",
            product: .staticLibrary,
            productName: "DomainRepositoryInterfaces",
            bundleId: "com.juinjangteam.juinjang.domain.repositoryinterfaces",
            sources: ["RepositoryInterfaces/**"]
        ),
        .make(
            name: "Services",
            product: .staticLibrary,
            productName: "DomainServices",
            bundleId: "com.juinjangteam.juinjang.domain.services",
            sources: ["Services/**"]
        ),
        .make(
            name: "Usecases",
            product: .staticLibrary,
            productName: "DomainUsecases",
            bundleId: "com.juinjangteam.juinjang.domain.usecases",
            sources: ["Usecases/**"],
            dependencies: [
                .domain(.usecaseInterfaces),
                .domain(.services),
                .domain(.repositoryInterfaces)
            ]
        ),
        .make(
            name: "UsecaseInterfaces",
            product: .staticLibrary,
            productName: "DomainUsecaseInterfaces",
            bundleId: "com.juinjangteam.juinjang.domain.usecaseinterfaces",
            sources: ["UsecaseInterfaces/**"]
        )
    ]
)
