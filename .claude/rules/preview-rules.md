# Preview Rules

## 핵심 규칙: Example 타겟에만 #Preview 작성

### ❌ Sources에 #Preview 금지
- 호스트 앱 없어서 타임아웃/noPreviewInfos 에러
- Reducer Effect가 mock 없이 실행됨
- 번들 리소스 경로 못 찾음

### ✅ Example 타겟에만 작성
```swift
// Feature/{Name}/Example/Sources/{Name}ExampleApp.swift
#Preview("이름") {
    {Name}View(
        store: Store(initialState: {Name}Feature.State()) {
            {Name}Feature()
        } withDependencies: {
            $0.someClient = .testValue
        }
    )
}
```

## 스킴 매핑
| Preview 대상 | 스킴 |
|-------------|------|
| Feature/Splash/ | SplashExample |
| Feature/Home/ | HomeExample |
| App/Sources/ | juinjang-dev |

## State Variant
- 별도 파일 생성 금지 → Example 앱에서 State 초기값으로 직접 관리
- Mock은 Testing/Mock에서 관리, TCA `.testValue` 우선

## 기존 인프라 우선
- `tuist scaffold Feature` → Example 타겟 자동 생성
- Preview 전용 파일 별도 생성 금지
