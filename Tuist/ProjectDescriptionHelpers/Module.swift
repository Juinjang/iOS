import ProjectDescription

// MARK: - 모듈 타입 정의
/// 모든 모듈의 경로와 이름을 중앙에서 관리합니다.
/// 새 모듈 추가 시 해당 enum에 case를 추가하면 경로가 자동 결정됩니다.

public enum ModuleType {
    case app
    case feature(Feature)
    case core(Core)
    case designSystem

    // MARK: - Feature 모듈 목록
    /// scaffold 후 여기에 case를 추가하세요.
    public enum Feature: String, CaseIterable {
        case home = "Home"
         case splash = "Splash"
         case onboarding = "Onboarding"
         case login = "Login"
    }

    // MARK: - Core 모듈 목록
    public enum Core: String, CaseIterable {
        case dependency = "Dependency"
        case networking = "Networking"
        case common = "Common"
        case model = "Model"
    }
}

// MARK: - 경로 & 이름 자동 생성

extension ModuleType {

    /// 모듈의 루트 기준 상대 경로
    public var path: Path {
        switch self {
        case .app:
            return "Projects/App"
        case .feature(let module):
            return "Projects/Feature/\(module.rawValue)"
        case .core(let module):
            return "Projects/Core/\(module.rawValue)"
        case .designSystem:
            return "Projects/DesignSystem"
        }
    }

    /// 모듈의 타깃 이름
    public var name: String {
        switch self {
        case .app:                  return "App"
        case .feature(let module):  return module.rawValue
        case .core(let module):     return module.rawValue
        case .designSystem:         return "DesignSystem"
        }
    }
}
