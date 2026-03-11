import ProjectDescription

// MARK: - 프로젝트 전체 공통 빌드 설정
/// configurations를 명시적으로 선언하여 캐싱 에러를 방지합니다.

extension Settings {

    public static let shared: Settings = .settings(
        base: [
            "SWIFT_VERSION": "6.0",
            "IPHONEOS_DEPLOYMENT_TARGET": "17.0",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "CODE_SIGN_IDENTITY": "",
            "SWIFT_STRICT_CONCURRENCY": "complete",
            "ENABLE_USER_SCRIPT_SANDBOXING": "NO"
        ],
        configurations: [
            .debug(
                name: "Debug",
                settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "SWIFT_OPTIMIZATION_LEVEL": "-Onone"
                ],
                xcconfig: AppTargetType.dev.xcconfigPath
            ),
            .release(
                name: "Release",
                settings: [
                    "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule"
                ],
                xcconfig: AppTargetType.prod.xcconfigPath
            )
        ]
    )
}
