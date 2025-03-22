// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings
    import ProjectDescriptionHelpers

    let packageSettings: PackageSettings = .make(
        productTypes: [
            SPM.alamofire: .staticFramework,
            SPM.amplitude: .staticFramework,
            SPM.dgCharts: .staticFramework,
            SPM.dsWaveformImage: .staticFramework,
            SPM.dsWaveformImageViews: .staticFramework,
            SPM.firebaseAnalytics: .staticFramework,
            SPM.fsCalendar: .staticFramework,
            SPM.iqKeyboardManager: .staticFramework,
            SPM.kakaoCommon: .staticFramework,
            SPM.kakaoShare: .staticFramework,
            SPM.kakaoAuth: .staticFramework,
            SPM.kakaoUser: .staticFramework,
            SPM.kingfisher: .staticFramework,
            SPM.lottie: .staticFramework,
            SPM.reactorKit: .staticFramework,
            SPM.realmSwift: .staticFramework,
            SPM.rxSwift: .staticFramework,
            SPM.rxCocoa: .staticFramework,
            SPM.rxDataSources: .staticFramework,
            SPM.skeletonView: .staticFramework,
            SPM.snapKit: .staticFramework,
            SPM.tabman: .staticFramework,
            SPM.then: .staticFramework,
            SPM.toast: .staticFramework,
        ]
    )
#endif

let package = Package(
    name: "juinjang",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.1"),
        .package(url: "https://github.com/amplitude/Amplitude-Swift", from: "1.0.0"),
        .package(url: "https://github.com/danielgindi/Charts", from: "5.0.0"),
        .package(url: "https://github.com/dmrschmidt/DSWaveformImage.git", from: "14.2.2"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.7.0"),
        .package(url: "https://github.com/WenchaoD/FSCalendar", from: "2.8.4"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", from: "6.5.16"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", exact: "2.22.5"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.10.2"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.4.0"),
        .package(url: "https://github.com/ReactorKit/ReactorKit", from: "3.2.0"),
        .package(url: "https://github.com/realm/realm-swift", exact: "10.47.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.8.0"),
        .package(url: "https://github.com/Juanpe/SkeletonView", from: "1.31.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.0"),
        .package(url: "https://github.com/uias/Tabman", from: "3.0.2"),
        .package(url: "https://github.com/devxoul/Then", from: "3.0.0"),
        .package(url: "https://github.com/scalessec/Toast-Swift", from: "5.1.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources", from: "5.0.2"),
    ]
)
