//
//  Project.swift
//  
//
//  Created by KimDongWoo on 8/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "DesignSystem",
    targets: [
        .make(
            name: "Resource",
            product: .staticLibrary,
            productName: "DesignSystem.Resource",
            bundleId: "com.juinjangteam.juinjang.designsystem.resource",
            sources: ["Resource/**"]
        ),
        .make(
            name: "Component",
            product: .staticLibrary,
            productName: "DesignSystem.Component",
            bundleId: "com.juinjangteam.juinjang.designsystem.component",
            sources: ["Component/**"],
            dependencies: [
                .designSystem(.resource)
            ]
        ),
    ]
)
