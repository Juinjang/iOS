

import ProjectDescription

public extension Target {
    static func target(
        for module: Module,
        appType: AppTargetType? = nil,
        product: Product,
        infoPlist: InfoPlist? = .default,
        resources: ResourceFileElements? = nil,
        entitlements: Entitlements? = nil,
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil
    ) -> Self {
        return Self.target(
            name: module != .app ? module.name : appType?.targetName ?? "",
            destinations: Environment.destinations,
            product: product,
            bundleId: module.bundleId,
            deploymentTargets: Environment.deploymentTargets,
            infoPlist: infoPlist,
            sources: .sources,
            resources: resources,
            entitlements: entitlements,
            dependencies: dependencies,
            settings: settings
        )
    }
    
    static func appTarget(
        appType: AppTargetType,
        appDependencies: [TargetDependency]
    ) -> Target {
        return .target(
            for: .app,
            appType: appType,
            product: .app,
            infoPlist: appType.plistFile,
            resources: .resources,
            entitlements: nil,
            dependencies: appDependencies,
            settings: .settings(
                base: appType.baseSettings,
                configurations: appType.baseConfigurations
            )
        )
    }
}
