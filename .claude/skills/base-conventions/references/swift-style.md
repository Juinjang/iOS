# Swift 스타일 및 프로젝트 규칙

## 버전 요구사항

- iOS 17.0+ (deploymentTarget)
- Swift 6.0 (SWIFT_VERSION)
- Swift Strict Concurrency: complete (SWIFT_STRICT_CONCURRENCY)

## 모듈 구조 및 의존성 방향

```
App
 ├── Feature/Splash
 ├── Feature/Onboarding
 ├── Feature/Login
 ├── Feature/Home
 ├── Core/Networking
 └── DesignSystem

Feature → Core, DesignSystem (의존 가능)
Feature → Feature (의존 금지)
Core → 외부 의존성만 (Alamofire 등)
DesignSystem → 외부 의존성만 (Lottie 등)
```

위반 시 순환 의존성 발생 → 빌드 실패

## 모듈 생성 규칙

새 모듈 생성 시 **`tuist scaffold` 템플릿을 우선 사용**:
```bash
tuist scaffold Feature --name MyPage
tuist scaffold Core --name Storage
```

Agent(feature-scaffold 등)는 scaffold로 커버 안 되는 커스텀 로직에만 활용.
이미 템플릿이 있는 산출물을 Agent가 중복 생성하지 않도록 주의.

## DesignSystem 에셋 추가 규칙

**ResourceSynthesizers가 단일 source of truth입니다.**
- 컬러: `Colors.xcassets/`에 추가 → `tuist generate` → 자동 extension 생성
- 이미지: `Assets.xcassets/`에 추가 → `tuist generate` → 자동 extension 생성
- 폰트: `Fonts/`에 추가 → `tuist generate` → 자동 extension 생성

**수동으로 DSColors.swift 같은 extension 파일을 별도로 만들지 않습니다.**
별도의 Assets 폴더를 새로 만들지 않고, 기존 폴더에 추가합니다.

## 네이밍 컨벤션

### 파일명
| 종류 | 네이밍 | 예시 |
|------|--------|------|
| Reducer | `{Name}Feature.swift` | `SplashFeature.swift` |
| View | `{Name}View.swift` | `SplashView.swift` |
| Tests | `{Name}FeatureTests.swift` | `SplashFeatureTests.swift` |
| Mock | `Mock{Name}Client.swift` | `MockAPIClient.swift` |
| Example | `{Name}ExampleApp.swift` | `SplashExampleApp.swift` |
| Dependency | `{Name}Client.swift` | `UserDefaultsClient.swift` |

### Action 네이밍
```swift
public enum Action {
    case view(View)           // View에서 발생하는 액션
    case delegate(Delegate)   // 부모에게 위임하는 액션
    case internal(Internal)   // 내부 로직용 (외부 노출 X)

    public enum View: Equatable {
        case onAppear
        case loginButtonTapped
        case emailChanged(String)
    }

    public enum Delegate: Equatable {
        case navigateToHome
        case didFinishOnboarding
    }
}
```

### State 네이밍
- Bool: `is` 접두사 — `isLoading`, `isLoggedIn`
- Optional: 타입 그대로 — `user: User?`
- Collection: 복수형 — `posts: [Post]`

## Sendable 준수

모든 public struct/enum에 `Sendable` 프로토콜 준수:
```swift
@Reducer
public struct SplashFeature: Sendable { ... }
```

## import 순서

1. Apple 프레임워크 (ComposableArchitecture, SwiftUI)
2. 프로젝트 모듈 (DesignSystem, Dependency, Model)
3. 외부 라이브러리 (Alamofire, Lottie)

알파벳 순 정렬.
