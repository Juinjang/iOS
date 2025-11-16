//
//  Project.swift
//  
//
//  Created by KimDongWoo on 8/18/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    moduleType: .presentation,
    targets: [
        .makeTarget(
            module: .presentation,
            product: .staticLibrary,
            dependencies: [
                .domain,
                .designSystem,
                .spm(.fsCalendar),
                .spm(.tabman),
                .spm(.toast),
                .spm(.rxSwift),
                .spm(.rxCocoa),
                .spm(.rxDataSources),
                .spm(.reactorKit),
                .spm(.dsWaveformImage),
                .spm(.dsWaveformImageViews),
            ]
        )
    ]
)
