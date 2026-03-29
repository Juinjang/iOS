# Tuist ProjectDescriptionHelpers DSL

## Module Definition (Module.swift)

All modules are registered centrally:

```swift
public enum ModuleType {
    case app
    case feature(Feature)
    case core(Core)
    case designSystem

    public enum Feature: String, CaseIterable {
        case home = "Home"
        case splash = "Splash"
        case onboarding = "Onboarding"
        case login = "Login"
        // Add new features here
    }

    public enum Core: String, CaseIterable {
        case dependency = "Dependency"
        case networking = "Networking"
        case common = "Common"
        case model = "Model"
    }
}
```

Path and name are auto-generated:
- `ModuleType.feature(.home).path` -> `"Projects/Feature/Home"`
- `ModuleType.feature(.home).name` -> `"Home"`
- `ModuleType.core(.networking).path` -> `"Projects/Core/Networking"`

## Dependency Declaration (TargetDependency+Module.swift)

Type-safe dependency helpers:

```swift
.feature(.home)                        // -> Projects/Feature/Home
.core(.dependency)                     // -> Projects/Core/Dependency
.designSystem                          // -> Projects/DesignSystem
.external(.composableArchitecture)     // -> TCA
.external(.alamofire)                  // -> Alamofire
```

## Feature Project Factory (Project+Feature.swift)

Auto-generates 4 targets (Source + Testing + Tests + Example):

```swift
Project.feature(
    module: .home,
    dependencies: [
        .core(.dependency),
        .core(.model),
        .core(.common)
    ],
    hasResources: false,
    includeExample: true
)
```

Every feature automatically gets:
- TCA (`ComposableArchitecture`) dependency
- `DesignSystem` dependency
- These are injected as `baseDependencies` in the helper

## App Target Configuration (AppTargetType.swift)

Two variants: Prod and Dev

| Property | Prod | Dev |
|----------|------|-----|
| Target name | `juinjang` | `juinjang-dev` |
| Display name | `주인장` | `주인장-개발` |
| App icon | `AppIcon` | `AppIcon-dev` |
| Bundle ID | `com.juinjangteam.juinjang` | `com.juinjangteam.juinjang` |

## Shared Settings (Settings+Shared.swift)

Common build settings applied to all targets via `.shared`.

## Adding a New Feature Module

1. Add case to `ModuleType.Feature`:
   ```swift
   case myNewFeature = "MyNewFeature"
   ```

2. Create directory: `Projects/Feature/MyNewFeature/`

3. Create `Project.swift`:
   ```swift
   let project = Project.feature(
       module: .myNewFeature,
       dependencies: [
           .core(.dependency),
           .core(.model)
       ]
   )
   ```

4. Create source directories:
   ```
   Sources/
   Testing/
   Tests/
   Example/Sources/
   ```

5. Add dependency in App's `Project.swift`:
   ```swift
   .feature(.myNewFeature)
   ```

6. Run `tuist generate`
