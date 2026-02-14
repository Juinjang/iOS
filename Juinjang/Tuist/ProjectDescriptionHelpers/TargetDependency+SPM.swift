
import ProjectDescription

// 타겟(앱, 프레임워크) 레벨에서 "이 패키지를 의존성으로 사용하겠다"를 표현
public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    static let Alamofire = Self.package(product: "Alamofire")
    static let SnapKit = Self.package(product: "SnapKit")
    static let Reachability = Self.package(product: "Reachability")
    
    private static func package(product: String) -> TargetDependency {
        return TargetDependency.package(product: product)
    }
}
