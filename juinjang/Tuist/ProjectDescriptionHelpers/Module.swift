
import ProjectDescription

public enum Module {
    case app
}

public extension Module {
    var name: String {
        switch self {
        case .app: "App"
        }
    }
    
    var bundleId: String {
        switch self {
        case .app:  Environment.organizationName
        // default:    Environment.organizationName + "." + name
        }
    }
    
    var path: Path {
        return .relativeToRoot("Projects/\(name)")
    }
}
