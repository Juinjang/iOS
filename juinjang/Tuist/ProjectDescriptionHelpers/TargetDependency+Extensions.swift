import ProjectDescription

public extension TargetDependency {
    static func spm(_ name: String) -> TargetDependency {
        return .external(name: name)
    }
}

extension PackageSettings {
    public static func make(
        productTypes: [SPM : Product] = [:],
        productDestinations: [String : Destinations] = [:],
        baseSettings: Settings = .settings(),
        targetSettings: [String : Settings] = [:],
        projectOptions: [String : Project.Options] = [:]
    ) -> PackageSettings {
        return .init(
            productTypes: Dictionary(
                uniqueKeysWithValues: productTypes.map { ($0.key.rawValue, $0.value) }
            ),
            productDestinations: productDestinations,
            baseSettings: baseSettings,
            targetSettings: targetSettings,
            projectOptions: projectOptions
        )
    }
}
