import Foundation
import ProjectDescription

extension Target {
    public static func make(
        name: String,
        destinations: Destinations = [.iPhone],
        product: Product,
        productName: String? = nil,
        bundleId: String = "com.juinjangteam",
        deploymentTargets: DeploymentTargets? = .iOS("15.0"),
        infoPlist: InfoPlist? = .extendingDefault(with: [
            "CFBundleLocalizations": ["ko", "en"],
            "CFBundleAllowMixedLocalizations": "YES"
        ]),
        sources: SourceFilesList? = ["Sources/**"],
        resources: ResourceFileElements? = ["Resources/**"],
        copyFiles: [CopyFilesAction]? = nil,
        headers: Headers? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [Module] = [],
        settings: Settings? = nil,
        coreDataModels: [CoreDataModel] = [],
        environmentVariables: [String: EnvironmentVariable] = [:],
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = [],
        buildRules: [BuildRule] = [],
        mergedBinaryType: MergedBinaryType = .disabled,
        mergeable: Bool = false
    ) -> Target {
        let dependencies = dependencies.map { $0.asTargetDependency() }
        let bundleId = "com.juinjangteam.\(name)"
        return .target(
            name: name,
            destinations: destinations,
            product: product,
            productName: productName,
            bundleId: bundleId,
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            copyFiles: copyFiles,
            headers: headers,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings,
            coreDataModels: coreDataModels,
            environmentVariables: environmentVariables,
            launchArguments: launchArguments,
            additionalFiles: additionalFiles,
            buildRules: buildRules,
            mergedBinaryType: mergedBinaryType,
            mergeable: mergeable
        )
    }
}
