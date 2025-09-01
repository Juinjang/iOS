//
//  Module.swift
//  Manifests
//
//  Created by KimDongWoo on 8/29/25.
//

import ProjectDescription

// MARK: - Module
public enum Module {
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
    public func asTargetDependency() -> TargetDependency {
        switch self {
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
}
