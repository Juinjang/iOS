import ProjectDescription

public enum Module {
    case core(Core)
    case spm(SPM)
}

public enum Core: String {
    case common = "Common"
}

public enum SPM: String {
    case alamofire = "Alamofire"
    case amplitude = "AmplitudeSwift"
    case dgCharts = "DGCharts"
    case dsWaveformImage = "DSWaveformImage"
    case dsWaveformImageViews = "DSWaveformImageViews"
    case firebaseAnalytics = "FirebaseAnalytics"
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
    case skeletonView = "SkeletonView"
    case snapKit = "SnapKit"
    case tabman = "Tabman"
    case then = "Then"
    case toast = "Toast"
}

extension Module {
    public func asTargetDependency() -> TargetDependency {
        switch self {
        case .core(let core):
            return .project(target: core.rawValue, path: .relativeToRoot("Projects/Core"))
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
