import Foundation
import ProjectDescription

// 다른 모듈에서 사용하는 ProductName, BundleID 규칙성을 발견해서 "\()" 적용해보기
// Module Type 하나로 쉽게 만들수 있게 만들고 의존성 추가 부분도 현재 모듈 타입에 맞춰서? 구현!

extension Target {
    public static func makeTarget(
        name: String,
        product: Product,
        productName: String? = nil,
        bundleId: String = "com.juinjangteam",
        infoPlist: InfoPlist? = .extendingDefault(with: [
            "CFBundleLocalizations": ["ko", "en"],
            "CFBundleAllowMixedLocalizations": "YES"
        ]),
        sources: SourceFilesList? = nil,
        resources: ResourceFileElements? = nil,
        entitlements: Entitlements? = nil,
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil
    ) -> Target {
        return .target(
            name: name,
            destinations: Environment.destinations,
            product: product,
            productName: productName,
            bundleId: bundleId,
            deploymentTargets: Environment.deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            entitlements: entitlements,
            dependencies: dependencies,
            settings: settings
        )
    }
    
    public static func makeAppTarget(appType: AppTargetType,
                                     appDependencies: [Module],
                                     appVersion: String,
                                     build: String) -> Target {
        return .makeTarget(
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
            dependencies: appDependencies.map { $0.asTargetDependency() },
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
