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
            productName: "Data.Storage",
            bundleId: "com.juinjangteam.juinjang.data.storage",
            sources: ["Storage/**"]
        ),
        .make(
            name: "APIs",
            product: .staticLibrary,
            productName: "Data.APIs",
            bundleId: "com.juinjangteam.juinjang.data.apis",
            sources: ["APIs/**"],
            dependencies: [
                .data(.network),
                .spm(.alamofire)
            ]
        ),
        .make(
            name: "Repositories",
            product: .staticLibrary,
            productName: "Data.Repositories",
            bundleId: "com.juinjangteam.juinjang.data.repositories",
            sources: ["Repositories/**"],
            dependencies: [
                .data(.apis),
                .data(.storage),
                .domain(.repositoryInterfaces)
            ]
        ),
        .make(
            name: "Network",
            product: .staticLibrary,
            productName: "Data.Network",
            bundleId: "com.juinjangteam.juinjang.data.network",
            sources: ["Network/**"],
            dependencies: [
                .data(.logging)
            ]
        ),
        .make(
            name: "Logging",
            product: .staticLibrary,
            productName: "Data.Logging",
            bundleId: "com.juinjangteam.juinjang.data.logging",
            sources: ["Logging/**"]
        )
    ]
)
