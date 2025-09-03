//
//  Module+Extensions.swift
//  Manifests
//
//  Created by KimDongWoo on 9/3/25.
//

import ProjectDescription

extension Module {
    // MARK: - Setup for Target Creation
    public func asDependency(relativeTo currentModule: Module) -> TargetDependency {
        switch (currentModule, self) {
        case (.core, .core(let subModule)):
            return .target(name: subModule.rawValue)
        case (.data, .data(let subModule)):
            return .target(name: subModule.rawValue)
        case (.domain, .domain(let subModule)):
            return .target(name: subModule.rawValue)
        case (.designSystem, .designSystem(let subModule)):
            return .target(name: subModule.rawValue)
        case (.presentation, .presentation(let subModule)):
            return .target(name: subModule.rawValue)
        default:
            return asTargetDependency()
        }
    }
    
    private func asTargetDependency() -> TargetDependency {
        switch self {
        case .app:
            fatalError("App 모듈은 다른 모듈에서 의존성으로 사용할 수 없습니다.")
        case .core(let subModule):
            return .project(
                target: subModule.rawValue,
                path: .relativeToRoot(ModuleBasePath.core.rawValue)
            )
        case .data(let subModule):
            return .project(
                target: subModule.rawValue,
                path: .relativeToRoot(ModuleBasePath.data.rawValue)
            )
        case .domain(let subModule):
            return .project(
                target: subModule.rawValue,
                path: .relativeToRoot(ModuleBasePath.domain.rawValue)
            )
        case .designSystem(let subModule):
            return .project(
                target: subModule.rawValue,
                path: .relativeToRoot(ModuleBasePath.designSystem.rawValue)
            )
        case .presentation(let subModule):
            return .project(
                target: subModule.rawValue,
                path: .relativeToRoot(ModuleBasePath.presentation.rawValue)
            )
        case .spm(let spm):
            return .external(name: spm.rawValue)
        }
    }
    
    public var moduleSubName: String {
        switch self {
        case .core(let target): return target.rawValue
        case .data(let target): return target.rawValue
        case .domain(let target): return target.rawValue
        case .designSystem(let target): return target.rawValue
        case .presentation(let target): return target.rawValue
        default: return ""
        }
    }
    
    public var defaultProductName: String {
        return "\(moduleName)\(moduleSubName)"
    }
    
    public var defaultBundleID: String {
        return "\(Environment.baseBundleId).juinjang.\(moduleName.lowercased()).\(moduleSubName.lowercased())"
    }
    
    public var defaultSources: SourceFilesList {
        return .sourceFilesList(globs: ["\(moduleSubName)/**"])
    }
    
    // MARK: - Setup for Project Creation
    public var moduleName: String {
        switch self {
        case .app: return "App"
        case .core: return "Core"
        case .data: return "Data"
        case .domain: return "Domain"
        case .designSystem: return "DesignSystem"
        case .presentation: return "Presentation"
        default: return ""
        }
    }
    
    public static var core: Module { .core(.common) }
    public static var data: Module { .data(.repositories) }
    public static var domain: Module { .domain(.services) }
    public static var designSystem: Module { .designSystem(.components) }
    public static var presentation: Module { .presentation(.scenes) }
}
