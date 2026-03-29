# TMA Interface Target Pattern

## Overview
The Interface target pattern separates a module's public API from its implementation.
This is the key technique for breaking circular dependencies in modular TCA projects.

## When to Adopt

Adopt the Interface pattern when:
- Feature A's navigation Path includes Feature B, and vice versa
- Multiple features need to reference each other's State/Action types
- You want to minimize recompilation when implementation changes

## Current Project State

The project currently uses 4 targets per feature (no Interface split yet):
```
Source -> Testing -> Tests -> Example
```

To adopt the full TMA pattern, add an Interface target:
```
Interface -> Source -> Testing -> Tests -> Example
```

## How to Add Interface Target

### 1. Update Project+Feature.swift

Add an Interface target to the feature helper:

```swift
// Interface target
.target(
    name: "\(name)Interface",
    destinations: .iOS,
    product: .staticFramework,
    bundleId: "com.juinjang.feature.\(name.lowercased()).interface",
    deploymentTargets: .iOS("17.0"),
    sources: ["Interface/Sources/**"],
    dependencies: [
        .external(.composableArchitecture)
        // + other Interface-only dependencies
    ],
    settings: .shared
)
```

Update the Source target to depend on Interface:
```swift
dependencies: allDependencies + [.target(name: "\(name)Interface")]
```

### 2. Update TargetDependency+Module.swift

Add Interface dependency helper:

```swift
public static func featureInterface(_ module: ModuleType.Feature) -> TargetDependency {
    .project(
        target: "\(module.rawValue)Interface",
        path: .relativeToRoot("Projects/Feature/\(module.rawValue)")
    )
}
```

Usage:
```swift
.featureInterface(.home)  // depends on HomeInterface only
```

### 3. Directory Structure with Interface

```
Projects/Feature/Home/
├── Interface/
│   └── Sources/
│       └── HomeRootFeature.swift      (struct + State + Action + Path)
├── Sources/
│   └── HomeRootFeature+Live.swift     (convenience init with Reduce logic)
├── Testing/
├── Tests/
└── Example/
```

### 4. Interface File Pattern

See `tca/references/interface-navigation.md` for the complete
`Reduce<State, Action>` injection pattern.

## Cross-Module Dependencies with Interface

```
FeatureHomeInterface       (no feature deps, only TCA)
     ^          ^
     |          |
FeatureHome    FeatureLogin
(implements)   (references HomeRootFeature.State for navigation)
```

FeatureLogin depends on `FeatureHomeInterface` (not `FeatureHome`),
so it can reference types without pulling in implementation.

## Migration Strategy

1. Start with root-level features that manage StackState navigation
2. Extract State/Action/Path into Interface target
3. Move reducer logic to Source target as extension with convenience init
4. Update dependent modules to use Interface dependencies
5. Gradually apply to child features as cross-module references grow
