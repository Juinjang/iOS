# TMA Dependency Rules

## Unidirectional Dependency Flow

```
App
 ├── Feature/* (all features)
 │    ├── Core/Dependency
 │    ├── Core/Common
 │    ├── Core/Model
 │    ├── DesignSystem
 │    └── TCA (ComposableArchitecture)
 │
 ├── Core/Networking (live implementations)
 │    ├── Core/Dependency
 │    ├── Core/Common
 │    ├── Core/Model
 │    └── Alamofire
 │
 └── Core/Dependency
      └── Core/Model
```

## Strict Rules

### 1. Feature modules MUST NOT depend on other Feature modules
```
// FORBIDDEN
Feature/Home -> Feature/Login
```
Cross-feature communication goes through:
- Delegate actions (bubbled up to parent)
- Shared dependencies (via Core/Dependency)

### 2. Feature modules MUST NOT depend on Core/Networking
```
// FORBIDDEN
Feature/Home -> Core/Networking
```
Features consume APIs through `@Dependency` interfaces defined in Core/Dependency.
Live implementations in Core/Networking are linked only at the App level.

### 3. Core modules MUST NOT depend on Feature modules
```
// FORBIDDEN
Core/Common -> Feature/Home
```

### 4. DesignSystem MUST NOT depend on Feature or Core (except Common)
```
// ALLOWED
DesignSystem -> Core/Common (if needed)

// FORBIDDEN
DesignSystem -> Feature/Home
DesignSystem -> Core/Networking
```

### 5. Dependencies flow downward only
```
App -> Feature -> Core -> (external packages)
              -> DesignSystem
```

## Dependency Declaration DSL

```swift
// In Project.swift files:
dependencies: [
    .feature(.home),                          // -> Feature/Home
    .core(.dependency),                       // -> Core/Dependency
    .core(.model),                            // -> Core/Model
    .designSystem,                            // -> DesignSystem
    .external(.composableArchitecture),       // -> TCA
    .external(.alamofire),                    // -> Alamofire
]
```

## Why These Rules Matter

1. **Compilation speed** - changing one feature doesn't recompile others
2. **Independent development** - features can be built/tested in isolation via Example app
3. **No circular dependencies** - clean dependency graph
4. **Substitutability** - swap implementations without touching features
