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
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(CFBundleDisplayName)",
                "CFBundleShortVersionString": "$(MARKETING_VERSION)",
                "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
                "UILaunchStoryboardName": "LaunchScreen",
                "UIUserInterfaceStyle": "Light",
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false
                ]
            ]),
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
