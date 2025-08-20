//
//  Project.swift
//  
//
//  Created by KimDongWoo on 8/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Presentation",
    targets: [
        .make(
            name: "Scene",
            product: .staticLibrary,
            productName: "Presentation.Scene",
            bundleId: "com.juinjangteam.juinjang.presentation.scene",
            sources: ["Scene/**"],
            dependencies: [
                .designSystem(.resource),
                .designSystem(.component),
                .domain(.usecaseInterface)
            ]
        ),
    ]
)
