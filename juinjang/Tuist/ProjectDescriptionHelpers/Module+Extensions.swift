//
//  Module+Extensions.swift
//  Manifests
//
//  Created by KimDongWoo on 9/3/25.
//

import ProjectDescription

extension Module {
    // MARK: - Setup for Target Creation
    public func asDependency() -> TargetDependency {
        switch self {
        case .app:
            fatalError("App 모듈은 다른 모듈에서 의존성으로 사용할 수 없습니다.")
        case .core,
                .data,
                .domain,
                .designSystem,
                .presentation:
            return .project(
                target: moduleName,
                path: .relativeToRoot("Projects/\(moduleName)")
            )
        case .spm(let spm):
            return .external(name: spm.rawValue)
        }
    }
    
    public var defaultProductName: String {
        return "\(moduleName)"
    }
    
    public var defaultBundleID: String {
        return "\(Environment.baseBundleId).juinjang.\(moduleName.lowercased())"
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
}
