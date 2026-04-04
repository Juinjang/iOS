# TMA Module-Specific Preview Rules

## Module Types and Preview Behavior

### Feature Modules (staticFramework)
Feature modules are built as `staticFramework` in Tuist. Static frameworks
**cannot** host Previews directly because Xcode needs a runnable target.

Solution: Use the **Example app scheme** (e.g., `SplashExample`, `HomeExample`).

### DesignSystem (dynamic framework)
DesignSystem is a dynamic framework. `Bundle.module` works correctly for
loading resources (colors, images, Lottie files). Previews can run directly
within the DesignSystem module.

## Example Scheme Setup

Each feature module in TMA has up to 5 targets:
```
Feature/Home/
├── Sources/           -> Main source (HomeFeature, HomeView)
├── Interface/         -> Public protocols / types
├── Testing/           -> Test helpers, mocks
├── Tests/             -> Unit tests
└── Example/           -> Example app for Preview
    └── Sources/
        └── AppDelegate.swift (or App entry point)
```

The **Example** target is a minimal app that hosts the feature for Preview.
Select the `HomeExample` scheme in Xcode before using Previews.

## Preview 파일 위치 — 핵심 규칙

### ❌ Sources에 #Preview 작성 금지
```swift
// ❌ Feature/Splash/Sources/SplashView.swift — 여기에 #Preview 작성하지 말 것
#Preview {
    SplashView(store: Store(...) { SplashFeature() })
    // → 호스트 앱이 없어서 타임아웃 발생
    // → Reducer Effect가 mock 없이 실행됨
    // → 번들 리소스(Lottie, 이미지) 경로를 못 찾을 수 있음
}
```

Sources는 프레임워크 타겟이라 **호스트 앱이 없어** Preview가 정상 동작하지 않음.
타임아웃, 크래시, noPreviewInfos 에러의 주요 원인.

### ✅ Example 타겟에만 #Preview 작성
```swift
// ✅ Feature/Splash/Example/Sources/SplashExampleApp.swift
#Preview {
    SplashView(
        store: Store(initialState: SplashFeature.State()) {
            SplashFeature()
        } withDependencies: {
            $0.userDefaultsClient = .testValue  // mock 의존성 주입
        }
    )
}
```

Example 타겟은 `.app` 제품이므로 호스트 앱이 존재하고,
`{Feature}Example` 스킴으로 Preview를 실행할 수 있음.

### Preview 실행 절차
1. Xcode 스킴을 `{Feature}Example` (예: `SplashExample`)로 변경
2. Example/Sources/ 내 파일에서 Preview 실행
3. Sources/ 내 View 파일의 #Preview는 모두 제거

## Dependency Chain for Preview

Keep the Preview dependency chain minimal:

```
Feature (Sources) -> DesignSystem -> Models
                  -> Core/Dependency (interfaces only)
```

The Preview should **never** depend on:
- `Core/Networking` (live implementations)
- Other feature modules
- The main `App` target

This keeps Preview compilation fast and isolated.

## Resource Access in Preview

### DesignSystem resources
DesignSystem is a dynamic framework, so `Bundle.module` works:

```swift
Image(.iconHome)           // via asset catalog
Color(.primaryBlue)        // via color catalog
LottieView(name: "splash") // via Lottie files in bundle
```

### Feature module resources
Feature modules are static frameworks. If a feature has its own resources
(rare -- most resources should be in DesignSystem), they are accessed through
the Example app's bundle at Preview time.

## Tuist Configuration Considerations

Ensure TCA and all sub-dependencies are set to `.framework` (dynamic) in
the Tuist dependency configuration. This is required for Xcode Previews to
work with TCA stores.

```
// In Tuist dependency configuration
// TCA and sub-deps must be .framework for Preview support
```

## Preview Compilation Speed Tips

1. **Minimize imports** -- only import what the view needs
2. **Avoid transitive dependencies** -- do not import `Networking` in Preview files
3. **Use forward declarations** -- if a type is only needed for Preview state,
   consider defining a simple mock struct instead of importing the full module
4. **Split large features** -- if a feature has 10+ views, consider splitting
   into sub-features with their own Previews

## Related
- `preview-principles.md` - Core Preview rules
- `preview-state-patterns.md` - State patterns used in Example/Sources
- TMA skill `module-structure.md` - Full 5-target module documentation
- TMA skill `dependency-rules.md` - Module dependency direction
