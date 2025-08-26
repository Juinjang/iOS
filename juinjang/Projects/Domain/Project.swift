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
            productName: "Domain.RepositoryInterfaces",
            bundleId: "com.juinjangteam.juinjang.domain.repositoryinterfaces",
            sources: ["RepositoryInterfaces/**"]
        ),
        .make(
            name: "Services",
            product: .staticLibrary,
            productName: "Domain.Services",
            bundleId: "com.juinjangteam.juinjang.domain.services",
            sources: ["Services/**"]
        ),
        .make(
            name: "Usecases",
            product: .staticLibrary,
            productName: "Domain.Usecases",
            bundleId: "com.juinjangteam.juinjang.domain.usecases",
            sources: ["Usecases/**"],
            dependencies: [
                .domain(.usecaseInterfaces)
            ]
        ),
        .make(
            name: "UsecaseInterfaces",
            product: .staticLibrary,
            productName: "Domain.UsecaseInterfaces",
            bundleId: "com.juinjangteam.juinjang.domain.usecaseinterfaces",
            sources: ["UsecaseInterfaces/**"]
        )
    ]
)
