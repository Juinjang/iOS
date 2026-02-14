//
//  Project.swift
//  Manifests
//
//  Created by 조유진 on 2/14/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let settings = Settings.settings(
    base: Environment.baseSetting,
    configurations: Environment.configurations,
    defaultSettings: .recommended
)

let project = Project(
    name: Module.data.name,
    settings: settings,
    targets: [
        .target(
            for: .data,
            product: .framework,
            infoPlist: .file(path: "Support/Info.plist"),
            dependencies: [
                .SPM.Alamofire,
                .module(.domain)
            ],
            settings: .settings(configurations: [
                .debug(name: "Debug", xcconfig: "Configurations/secrets.xcconfig"),
                .release(name: "Release", xcconfig: "Configurations/secrets.xcconfig")
            ])
        )
    ]
)
