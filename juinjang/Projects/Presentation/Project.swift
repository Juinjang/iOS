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
            name: Module.presentation(.scenes),
            product: .staticLibrary,
            productName: "PresentationScenes",
            bundleId: "com.juinjangteam.juinjang.presentation.scenes",
            sources: ["Scenes/**"],
            dependencies: [
                .designSystem(.resources),
                .designSystem(.components),
                .domain(.usecaseInterfaces)
            ]
        ),
    ]
)
