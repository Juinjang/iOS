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
            productName: "Core.Storage",
            bundleId: "com.juinjangteam.juinjang.data.storage",
            sources: ["Storage/**"],
            dependencies: []
        ),
        .make(
            name: "API",
            product: .staticLibrary,
            productName: "Core.API",
            bundleId: "com.juinjangteam.juinjang.data.api",
            sources: ["API/**"],
            dependencies: [
                .core(.network),
                .spm(.alamofire)
            ]
        ),
        .make(
            name: "Repository",
            product: .staticLibrary,
            productName: "Core.Repository",
            bundleId: "com.juinjangteam.juinjang.data.repository",
            sources: ["Repository/**"],
            dependencies: [
                .data(.api),
                .data(.storage),
                .domain(.repositoryInterface)
            ]
        ),
    ]
)
