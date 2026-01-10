
import ProjectDescription

public extension TargetDependency {
    static func module(_ module: Module) -> TargetDependency {
        return TargetDependency.project(target: module.name, path: module.path)
    }
}
