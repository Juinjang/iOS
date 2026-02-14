
import ProjectDescription

public enum Module {
    case app
    case core
    case data
    case designSystem
    case diKit
    case domain
    case presentation
}

public extension Module {
    var name: String {
        switch self {
        case .app:              return "App"
        case .core:             return "Core"
        case .data:             return "Data"
        case .designSystem:     return "DesignSystem"
        case .diKit:            return "DIKit"
        case .domain:           return "Domain"
        case .presentation:     return "Presentation"
        }
    }
    
    var bundleId: String {
        switch self {
        case .app:  Environment.organizationName
         default:    Environment.organizationName + "." + name
        }
    }
    
    var path: Path {
        return .relativeToRoot("Projects/\(name)")
    }
}
