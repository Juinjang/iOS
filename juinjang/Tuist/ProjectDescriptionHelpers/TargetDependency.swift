import ProjectDescription

public enum Module {
    case spm(SPM)
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
    case rxDataSources = "RxDataSources"
    case skeletonView = "SkeletonView"
    case snapKit = "SnapKit"
    case tabman = "Tabman"
    case then = "Then"
    case toast = "Toast"
}

extension Module {
    public func asTargetDependency() -> TargetDependency {
        switch self {
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
