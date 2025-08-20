import ProjectDescription

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
    case network = "Network"
    case logging = "Logging"
}

public enum Data: String {
    case storage = "Storage"
    case api = "API"
    case repository = "Repository"
}

public enum Domain: String {
    case repositoryInterface = "RepositoryInterface"
    case usecase = "Usecase"
    case usecaseInterface = "UsecaseInterface"
}

public enum DesignSystem: String {
    case resource = "Resource"
    case component = "Component"
}

public enum Presentation: String {
    case scene = "Scene"
}

public enum SPM: String {
    case alamofire = "Alamofire"
    case amplitude = "AmplitudeSwift"
    case dgCharts = "DGCharts"
    case dsWaveformImage = "DSWaveformImage"
    case dsWaveformImageViews = "DSWaveformImageViews"
    case firebaseAnalytics = "FirebaseAnalytics"
    case firebaseFirestore = "FirebaseFirestore"
    case fsCalendar = "FSCalendar"
    case iqKeyboardManager = "IQKeyboardManagerSwift"
    case kakaoCommon = "KakaoSDKCommon"
    case kakaoAuth = "KakaoSDKAuth"
    case kakaoShare = "KakaoSDKShare"
    case kakaoUser = "KakaoSDKUser"
    case kingfisher = "Kingfisher"
    case lottie = "Lottie"
    case reactorKit = "ReactorKit"
    case realmSwift = "RealmSwift"
    case rxSwift = "RxSwift"
    case rxCocoa = "RxCocoa"
    case rxDataSources = "RxDataSources"
    case skeletonView = "SkeletonView"
    case snapKit = "SnapKit"
    case tabman = "Tabman"
    case then = "Then"
    case toast = "Toast"
}

public enum ModuleBasePath: String, CaseIterable {
    case core = "Projects/Core"
    case data = "Projects/Data"
    case domain = "Projects/Domain"
    case designSystem = "Projects/DesignSystem"
    case presentation = "Projects/Presentation"
}

extension Module {
    public var basePath: ModuleBasePath? {
        switch self {
        case .core: return .core
        case .data: return .data
        case .domain: return .domain
        case .designSystem: return .designSystem
        case .presentation: return .presentation
        case .spm: return nil
        }
    }
}

extension Module {
    public func asTargetDependency() -> TargetDependency {
        switch self {
        case .core(let m):
            return .project(target: m.rawValue, path: .relativeToRoot(ModuleBasePath.core.rawValue))
        case .data(let m):
            return .project(target: m.rawValue, path: .relativeToRoot(ModuleBasePath.data.rawValue))
        case .domain(let m):
            return .project(target: m.rawValue, path: .relativeToRoot(ModuleBasePath.domain.rawValue))
        case .designSystem(let m):
            return .project(target: m.rawValue, path: .relativeToRoot(ModuleBasePath.designSystem.rawValue))
        case .presentation(let m):
            return .project(target: m.rawValue, path: .relativeToRoot(ModuleBasePath.presentation.rawValue))
        case .spm(let spm):
            return .external(name: spm.rawValue)
        }
    }
}

extension PackageSettings {
    public static func make(
        productTypes: [SPM : Product] = [:],
        productDestinations: [String : Destinations] = [:],
        baseSettings: Settings = .settings(),
        targetSettings: [String : Settings] = [:],
        projectOptions: [String : Project.Options] = [:]
    ) -> PackageSettings {
        let productTypes: [String : Product] = productTypes.map { [$0.key.rawValue: $0.value] }.first!
        return .init(
            productTypes: productTypes,
            productDestinations: productDestinations,
            baseSettings: baseSettings,
            targetSettings: targetSettings,
            projectOptions: projectOptions
        )
    }
}
