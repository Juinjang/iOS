//
//  Project.swift
//  
//
//  Created by KimDongWoo on 8/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Data",
    targets: [
        .make(
            name: "Storage",
            product: .staticLibrary,
            productName: "DataStorage",
            bundleId: "com.juinjangteam.juinjang.data.storage",
            sources: ["Storage/**"]
        ),
        .make(
            name: "Network",
            product: .staticLibrary,
            productName: "DataNetwork",
            bundleId: "com.juinjangteam.juinjang.data.network",
            sources: ["Network/**"]
        ),
        .make(
            name: "Repositories",
            product: .staticLibrary,
            productName: "DataRepositories",
            bundleId: "com.juinjangteam.juinjang.data.repositories",
            sources: ["Repositories/**"],
            dependencies: [
                .data(.storage),
                .domain(.repositoryInterfaces)
            ]
        )
    ]
)
