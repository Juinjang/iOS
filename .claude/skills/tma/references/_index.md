# TMA Quick Reference Index

## Overview
The Modular Architecture (TMA) for Tuist-based iOS projects.
Tailored to **Juinjang iOS** project structure.

## Project Config
- Tuist with `ProjectDescriptionHelpers` custom DSL
- Swift 6.0, iOS 17.0+
- TCA as `.framework` (dynamic) for Preview support
- Strict concurrency: `complete`

## Module Layout
```
Projects/
├── App/              -> Main app targets (Prod + Dev)
├── Feature/          -> Feature modules
│   ├── Home/
│   ├── Splash/
│   ├── Onboarding/
│   └── Login/
├── Core/             -> Shared infrastructure
│   ├── Dependency/   -> DI container (@DependencyClient interfaces)
│   ├── Networking/   -> Live implementations (DependencyKey)
│   ├── Model/        -> Shared domain models
│   └── Common/       -> Utilities, extensions
├── DesignSystem/     -> Reusable UI components
└── XCConfig/         -> Build configurations
```

## Reference Files

| File | Topic |
|------|-------|
| `module-structure.md` | 5-target module pattern |
| `dependency-rules.md` | Dependency direction and boundaries |
| `tuist-helpers.md` | Project DSL helpers |
| `feature-module-guide.md` | Step-by-step new module guide |
| `interface-pattern.md` | Interface/Implementation split |
