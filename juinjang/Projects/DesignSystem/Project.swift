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
            name: "Resources",
            product: .staticLibrary,
            productName: "DesignSystem.Resources",
            bundleId: "com.juinjangteam.juinjang.designsystem.resources",
            sources: ["Resources/**"]
        ),
        .make(
            name: "Components",
            product: .staticLibrary,
            productName: "DesignSystem.Components",
            bundleId: "com.juinjangteam.juinjang.designsystem.components",
            sources: ["Components/**"],
            dependencies: [
                .designSystem(.resources)
            ]
        ),
    ]
)
