# Code Conventions

## 프로젝트 기본
- iOS 17.0+, Swift 6.0, TCA 1.24.1+, Tuist 4.43.2+
- Swift Strict Concurrency: complete

## TCA 패턴
- `@Bindable` 사용 (NOT `@Perception.Bindable`)
- `WithPerceptionTracking` 불필요 (iOS 17+ @Observable 네이티브)
- `@Reducer`, `@ObservableState` 매크로 사용
- State: `Equatable` 준수
- Action: `view(View)`, `delegate(Delegate)` 패턴
- Side Effect는 View가 아닌 Reducer에서 처리

## View 구조
```swift
public struct {Name}View: View {
    @Bindable public var store: StoreOf<{Name}Feature>
    public init(store: StoreOf<{Name}Feature>) { self.store = store }
    public var body: some View { ... }
}
```

## Import 규칙
- Feature에서 `UIKit` import 금지
- `AppInfo` 상수는 Feature에서 직접 접근 허용
- `Bundle.main` 직접 접근 금지 → Client를 통해 간접 접근
- import 순서: Apple 프레임워크 → 프로젝트 모듈 → 외부 라이브러리 (알파벳순)

## API 네이밍 (DependencyClient)
- GET (프로퍼티 스타일): `latestVersion`, `currentVersion`, `notes`, `noteDetail`
- POST: `createNote`, `createRecord`
- PATCH/PUT: `updateProfile`, `updateNote`
- DELETE: `removeItem`, `removeRecord`
- Feature는 데이터 출처(원격/로컬)를 몰라야 함

## 파일 네이밍
| 종류 | 패턴 | 예시 |
|------|------|------|
| Reducer | `{Name}Feature.swift` | `SplashFeature.swift` |
| View | `{Name}View.swift` | `SplashView.swift` |
| ViewModel | `{Name}View+Model.swift` | `MyNoteListView+Model.swift` |
| 하위 View | `{Name}ItemView.swift` | `MyNoteListItemView.swift` |
| Tests | `{Name}FeatureTests.swift` | `SplashFeatureTests.swift` |
| Mock | `Mock{Name}Data.swift` | `MockMyNoteListData.swift` |
| Example | `{Name}ExampleApp.swift` | `SplashExampleApp.swift` |

## Action 네이밍
```swift
public enum Action {
    case onAppear
    case loginButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
        case navigateTo(Route)
    }
}
```

## State 네이밍
- Bool: `is`/`show` 접두사 — `isLoading`, `showUpdatePopup`
- Optional: 타입 그대로 — `user: User?`
- Collection: 복수형 — `posts: [Post]`

## Sendable
- 모든 public struct/enum에 `Sendable` 준수
- `@Reducer` struct에 `: Sendable` 명시
