# Info.plist 관련 이슈

## 1. 검정화면 (Black Screen on Launch)

### 증상
- 앱 빌드 성공 후 실행하면 검정화면만 표시
- SwiftUI @main 앱에서 View가 렌더링되지 않는 것처럼 보임

### 원인
`Target+Extensions.swift`에서 `infoPlist: .default` 사용 시
Tuist가 최소한의 기본 plist만 생성하여 필수 키가 누락됨.

develop 브랜치(UIKit)에서는 커스텀 Info.plist에 포함되어 있던 키들이
SwiftUI @main으로 전환하면서 `.default`로 변경 시 빠짐.

### 누락되는 필수 키
- `UILaunchStoryboardName` - 없으면 윈도우 크기가 제대로 설정 안 됨
- `UIApplicationSceneManifest` - Scene 설정

### 해결
```swift
// Target+Extensions.swift
infoPlist: .extendingDefault(with: [
    "CFBundleDisplayName": "$(CFBundleDisplayName)",
    "UILaunchStoryboardName": "LaunchScreen",
    "UIUserInterfaceStyle": "Light",
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false
    ]
]),
```

### 주의사항
- `.default` 대신 `.extendingDefault(with:)`를 사용해야 커스텀 키 추가 가능
- develop 브랜치의 기존 Info.plist를 참고하여 필요한 키를 확인할 것
- `UILaunchStoryboardName`은 SwiftUI 앱에서도 반드시 필요

---

## 2. 다크모드에서 Safe Area 검정 영역

### 증상
- 시뮬레이터 다크모드에서 상하단 Safe Area가 검정으로 표시
- 흰색 콘텐츠 영역이 가운데만 차지

### 원인
`UIUserInterfaceStyle`이 설정되지 않아 시스템 테마를 따름.
다크모드에서는 시스템 배경색이 검정.

### 해결
Info.plist에 `UIUserInterfaceStyle: Light` 추가하여 라이트 모드 고정.

```swift
"UIUserInterfaceStyle": "Light",
```

### 대안
각 View에서 개별 처리 (비권장):
```swift
Color.white.ignoresSafeArea() // View마다 추가해야 해서 번거로움
```

---

## 3. develop 브랜치 Info.plist 주요 키 목록 (참고용)

UIKit 기반 develop 브랜치에서 사용하던 키:
- `UIApplicationSceneManifest` (SceneDelegate 매핑)
- `UILaunchStoryboardName`: LaunchScreen
- `UIUserInterfaceStyle`: Light
- `UIRequiresFullScreen`: true
- `UISupportedInterfaceOrientations`: Portrait only
- `UIAppFonts`: Pretendard, omyu pretty 폰트
- `CFBundleURLTypes`: Kakao SDK URL scheme
- `NSAppTransportSecurity`: AllowsArbitraryLoads
- `NSCameraUsageDescription`, `NSMicrophoneUsageDescription` 등 권한 설명
