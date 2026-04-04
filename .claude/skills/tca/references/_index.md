# TCA Quick Reference Index

## Target Version
- swift-composable-architecture **1.24.1+**
- Swift 6.0, iOS 17.0+
- All TCA sub-dependencies set to `.framework` for Xcode Preview support

## iOS Compatibility
- Minimum deployment target: **iOS 17.0**
- `@ObservableState` + `@Bindable` = iOS 17+ native observation
- Never use raw `@Observable` macro — always use `@ObservableState` for TCA
- `NavigationStack` = iOS 16+ (프로젝트 최소 타겟은 iOS 17.0) ✅
- `LottieView` (Lottie 4.x) = iOS 16+ ✅ (use this, NOT `UIViewRepresentable` + `LottieAnimationView`)
- `.onChange(of:perform:)` deprecated iOS 17 → use `.onChange(of:initial:_:)` with `#available` if needed

## Key Imports
```swift
import ComposableArchitecture
```

## Core Concepts at a Glance

| Concept | File | Key Types |
|---------|------|-----------|
| Reducer | `reducer-basics.md` | `@Reducer`, `State`, `Action`, `body` |
| Navigation | `navigation.md` | `StackState`, `StackAction`, `@Reducer(state:) enum Path` |
| Interface Nav | `interface-navigation.md` | `Reduce<State, Action>` injection pattern |
| Dependencies | `dependencies.md` | `@Dependency`, `DependencyKey`, `DependencyClient` |
| Effects | `effects.md` | `Effect<Action>`, `.run`, `.send`, `.cancel` |
| Testing | `testing.md` | `TestStore`, `.send`, `.receive`, `withDependencies` |
| Bindings | `bindings.md` | `@BindableState`, `BindableAction` |
| Shared State | `shared-state.md` | `@Shared`, `PersistenceKey` |
| Composition | `composition.md` | `Scope`, `ifLet`, `forEach` |

## Project-Specific Notes
- TCA is used as `.framework` (dynamic) for Xcode Preview compatibility
- All sub-dependencies (CasePaths, Dependencies, Perception, etc.) are also `.framework`
- Features depend on TCA via `.external(.composableArchitecture)`
