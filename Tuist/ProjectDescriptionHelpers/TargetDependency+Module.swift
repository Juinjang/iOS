import ProjectDescription

// MARK: - 타입 안전한 의존성 선언
/// 사용법:
///   .feature(.home)   → Projects/Feature/Home
///   .core(.network)   → Projects/Core/Network
///   .designSystem     → Projects/DesignSystem
///   .tca              → ComposableArchitecture

extension TargetDependency {

    // MARK: - Feature

    public static func feature(_ module: ModuleType.Feature) -> TargetDependency {
        .project(
            target: module.rawValue,
            path: .relativeToRoot("Projects/Feature/\(module.rawValue)")
        )
    }

    // MARK: - Core

    public static func core(_ module: ModuleType.Core) -> TargetDependency {
        .project(
            target: module.rawValue,
            path: .relativeToRoot("Projects/Core/\(module.rawValue)")
        )
    }

    // MARK: - DesignSystem

    public static var designSystem: TargetDependency {
        .project(
            target: "DesignSystem",
            path: .relativeToRoot("Projects/DesignSystem")
        )
    }

    // MARK: - External
    
    public static func external(_ externalDependency: ExternalDependency) -> TargetDependency {
        return .external(name: externalDependency.rawValue)
    }
    
    public enum ExternalDependency: String {
        case composableArchitecture = "ComposableArchitecture"
        case alamofire = "Alamofire"
    }
}
