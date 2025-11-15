import Foundation
import ProjectDescription

extension Target {
    public static func makeTarget(
        module: Module,
        name: String? = nil,
        product: Product,
        productName: String? = nil,
        bundleId: String? = "com.juinjangteam",
        infoPlist: InfoPlist? = .extendingDefault(with: [
            "CFBundleLocalizations": ["ko", "en"],
            "CFBundleAllowMixedLocalizations": "YES"
        ]),
        sources: SourceFilesList? = nil,
        resources: ResourceFileElements? = nil,
        entitlements: Entitlements? = nil,
        dependencies: [Module] = [],
        settings: Settings? = nil
    ) -> Target {
        return .target(
            name: name ?? module.moduleName,
            destinations: Environment.destinations,
            product: product,
            productName: productName ?? module.defaultProductName,
            bundleId: bundleId ?? module.defaultBundleID,
            deploymentTargets: Environment.deploymentTarget,
            infoPlist: infoPlist,
            sources: sources ?? "Sources/**",
            resources: resources,
            entitlements: entitlements,
            dependencies: dependencies.map {
                $0.asDependency()
            },
            settings: settings
        )
    }
    
    public static func makeAppTarget(appType: AppTargetType,
                                     appDependencies: [Module],
                                     appVersion: String,
                                     build: String) -> Target {
        return .makeTarget(
            module: .app,
            name: appType.targetName,
            product: .app,
            bundleId: appType.bundleID,
            infoPlist: appType.plistFile,
            sources: [
                "Sources/**"
            ],
            resources: [
                "Resources/**",
                "\(appType.storeKitFilePaths)"
            ],
            entitlements: .file(path: appType.entitlementsPath),
            dependencies: appDependencies,
            settings: .settings(
                base: appType.baseSettings.merging([
                    "MARKETING_VERSION": "\(appVersion)",
                    "CURRENT_PROJECT_VERSION": "\(build)"
                ]),
                configurations: appType.baseConfigurations
            )
        )
    }
}
