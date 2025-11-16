//
//  Project.swift
//  
//
//  Created by KimDongWoo on 8/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    moduleType: .data,
    targets: [
        .makeTarget(
            module: .data,
            product: .staticLibrary,
            dependencies: [
                .domain,
                .core,
                .spm(.rxSwift),
                .spm(.realmSwift)
            ]
        )
    ]
)
