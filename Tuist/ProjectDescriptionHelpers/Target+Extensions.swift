//
//  Target+Extensions.swift
//  Manifests
//
//  Created by 조유진 on 3/11/26.
//

import Foundation
import ProjectDescription

extension Target {
    
    public static func makeAppTarget(
        appType: AppTargetType,
        appDependencies: [TargetDependency],
    ) -> Target {
        return .target(
            name: appType.targetName,
            destinations: Environment.destinations,
            product: .app,
            productName: appType.displayName,
            bundleId: appType.bundleID,
            deploymentTargets: Environment.deploymentTarget,
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: appDependencies,
            settings: .settings(
                base: appType.baseSettings,
                configurations: appType.baseConfigurations
            )
        )
    }
}
