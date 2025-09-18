//
//  Module.swift
//  Manifests
//
//  Created by KimDongWoo on 8/29/25.
//

import ProjectDescription

// MARK: - Module
public enum Module: Sendable, Equatable {
    case app
    case core(Core)
    case data(Data)
    case domain(Domain)
    case designSystem(DesignSystem)
    case presentation(Presentation)
    case spm(SPM)
}

public enum Core: String, Sendable{
    case common = "Common"
}

public enum Data: String, Sendable {
    case model = "Model"
    case storage = "Storage"
    case network = "Network"
    case repositories = "Repositories"
}

public enum Domain: String, Sendable {
    case model = "Model"
    case repositoryInterfaces = "RepositoryInterfaces"
    case services = "Services"
    case usecases = "Usecases"
    case usecaseInterfaces = "UsecaseInterfaces"
}

public enum DesignSystem: String, Sendable {
    case resources = "Resources"
    case components = "Components"
}

public enum Presentation: String, Sendable {
    case scenes = "Scenes"
}

public enum ModuleBasePath: String, CaseIterable {
    case core = "Projects/Core"
    case data = "Projects/Data"
    case domain = "Projects/Domain"
    case designSystem = "Projects/DesignSystem"
    case presentation = "Projects/Presentation"
}
