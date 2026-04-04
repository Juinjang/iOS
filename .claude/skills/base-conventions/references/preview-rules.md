# Preview 규칙

## 핵심 규칙: Example 타겟에만 #Preview 작성

### ❌ Sources에 #Preview 금지
```swift
// ❌ Feature/Splash/Sources/SplashView.swift
#Preview {
    SplashView(store: Store(...) { SplashFeature() })
}
// → 호스트 앱 없음 → 타임아웃/noPreviewInfos 에러
// → Reducer Effect가 mock 없이 실행됨
// → 번들 리소스 경로 못 찾음
```

### ✅ Example 타겟에 #Preview 작성
```swift
// ✅ Feature/Splash/Example/Sources/SplashExampleApp.swift
#Preview {
    SplashView(
        store: Store(initialState: SplashFeature.State()) {
            SplashFeature()
        } withDependencies: {
            $0.userDefaultsClient = .testValue
        }
    )
}
```

## Preview 실행 절차

1. Xcode 스킴을 `{Feature}Example` (예: `SplashExample`)로 변경
2. Example/Sources/ 내 파일에서 Preview 실행
3. Sources/ 내 View 파일에는 #Preview 작성하지 않음

## 스킴 매핑

| Preview 대상 | 선택할 스킴 |
|-------------|------------|
| Feature/Splash/ | SplashExample |
| Feature/Home/ | HomeExample |
| Feature/Login/ | LoginExample |
| Feature/Onboarding/ | OnboardingExample |
| App/Sources/ | juinjang-dev |

## mock 의존성 주입

Preview Store 생성 시 `withDependencies`로 mock 주입:
```swift
Store(initialState: MyFeature.State()) {
    MyFeature()
} withDependencies: {
    $0.apiClient = .testValue
    $0.userDefaultsClient = .testValue
}
```

## 기존 인프라 우선 사용

- `tuist scaffold Feature --name X` → Example 타겟 자동 생성됨
- preview-builder Agent는 scaffold로 커버 안 되는 복잡한 Preview 구성에만 사용
