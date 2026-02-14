
import ProjectDescription

// 프로젝트 레벨에서 SPM 패키지를 선언
public extension Package {
    struct SPM {}
}

public extension Package.SPM {
    static let Alamofire = Package.remote(
        url: "https://github.com/Alamofire/Alamofire.git",
        requirement: .upToNextMajor(from: "5.11.0")
    )
    
    static let SnapKit = Package.remote(
        url: "https://github.com/SnapKit/SnapKit.git",
        requirement: .upToNextMajor(from: "5.0.1")
    )
    
    static let Reachability = Package.remote(
        url: "https://github.com/ashleymills/Reachability.swift",
        requirement: .upToNextMajor(from: "5.0.0")
    )
    
    static let ComposableArchitecture = Package.remote(
        url: "https://github.com/pointfreeco/swift-composable-architecture.git",
        requirement: .upToNextMajor(from: "1.23.1")
    )
}
