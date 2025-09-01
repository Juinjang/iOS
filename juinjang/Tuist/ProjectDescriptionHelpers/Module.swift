//
//  Module.swift
//  Manifests
//
//  Created by KimDongWoo on 8/29/25.
//

import ProjectDescription

// MARK: - Module
public enum Module: Equatable {
    case app
    case core(Core)
    case data(Data)
    case domain(Domain)
    case designSystem(DesignSystem)
    case presentation(Presentation)
    case spm(SPM)
}

public enum Core: String {
    case common = "Common"
}

public enum Data: String {
    case storage = "Storage"
    case apis = "APIs"
    case repositories = "Repositories"
    case network = "Network"
    case logging = "Logging"
}

public enum Domain: String {
    case repositoryInterfaces = "RepositoryInterfaces"
    case services = "Services"
    case usecases = "Usecases"
    case usecaseInterfaces = "UsecaseInterfaces"
}

public enum DesignSystem: String {
    case resources = "Resources"
    case components = "Components"
}

public enum Presentation: String {
    case scenes = "Scenes"
}

public enum ModuleBasePath: String, CaseIterable {
    case core = "Projects/Core"
    case data = "Projects/Data"
    case domain = "Projects/Domain"
    case designSystem = "Projects/DesignSystem"
    case presentation = "Projects/Presentation"
}

extension Module {
    public func asDependency(relativeTo currentModule: Module) -> TargetDependency {
        switch (currentModule, self) {
        case (.core, .core(let m)):
            return .target(name: m.rawValue)
        case (.data, .data(let m)):
            return .target(name: m.rawValue)
        case (.domain, .domain(let m)):
            return .target(name: m.rawValue)
        case (.designSystem, .designSystem(let m)):
            return .target(name: m.rawValue)
        case (.presentation, .presentation(let m)):
            return .target(name: m.rawValue)
        default:
            return self.asTargetDependency()
        }
    }
    
    private func asTargetDependency() -> TargetDependency {
        switch self {
        case .app:
            fatalError("App 모듈은 다른 모듈에서 의존성으로 사용할 수 없습니다.")
        case .core(let m):
            return .project(
                target: m.rawValue,
                path: .relativeToRoot(ModuleBasePath.core.rawValue)
            )
        case .data(let m):
            return .project(
                target: m.rawValue,
                path: .relativeToRoot(ModuleBasePath.data.rawValue)
            )
        case .domain(let m):
            return .project(
                target: m.rawValue,
                path: .relativeToRoot(ModuleBasePath.domain.rawValue)
            )
        case .designSystem(let m):
            return .project(
                target: m.rawValue,
                path: .relativeToRoot(ModuleBasePath.designSystem.rawValue)
            )
        case .presentation(let m):
            return .project(
                target: m.rawValue,
                path: .relativeToRoot(ModuleBasePath.presentation.rawValue)
            )
        case .spm(let spm):
            return .external(name: spm.rawValue)
        }
    }
    
    // MARK: - Setup for Target Creation
    public var moduleSubName: String {
        switch self {
        case .core(let c): return c.rawValue
        case .data(let d): return d.rawValue
        case .domain(let d): return d.rawValue
        case .designSystem(let d): return d.rawValue
        case .presentation(let p): return p.rawValue
        default: return ""
        }
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
    
    // MARK: - Setup for Project Creation
    public static var core: Module { .core(.common) }
    public static var data: Module { .data(.apis) }
    public static var domain: Module { .domain(.services) }
    public static var designSystem: Module { .designSystem(.components) }
    public static var presentation: Module { .presentation(.scenes) }
}
