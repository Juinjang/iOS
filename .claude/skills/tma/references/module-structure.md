# TMA Module Structure

## 5-Target Pattern Per Feature

Each feature module can have up to 5 targets:

| Target | Name Pattern | Product | Purpose |
|--------|-------------|---------|---------|
| **Source** | `{Name}` | staticFramework | Feature implementation |
| **Interface** | `{Name}Interface` | staticFramework | Public types only (State, Action, Path) |
| **Testing** | `{Name}Testing` | staticFramework | Mocks, stubs, test data |
| **Tests** | `{Name}Tests` | unitTests | Unit and integration tests |
| **Example** | `{Name}Example` | app | Standalone demo app |

## Current Project Targets

The project currently generates 4 targets per feature (no Interface target yet):

```
Feature/Home/
├── Sources/       -> Home (staticFramework)
├── Testing/       -> HomeTesting (staticFramework)
├── Tests/         -> HomeTests (unitTests)
└── Example/       -> HomeExample (app)
```

## Target Dependencies

```
                    ┌─────────────┐
                    │   Example    │
                    └──────┬──────┘
                           │ depends on
              ┌────────────┼────────────┐
              v            v            v
        ┌──────────┐ ┌──────────┐ ┌──────────────┐
        │  Source   │ │ Testing  │ │     TCA      │
        └────┬─────┘ └────┬─────┘ └──────────────┘
             │            │
             v            v
        ┌──────────────────────┐
        │     Interface        │  (future: when adopted)
        └──────────────────────┘

        ┌──────────┐
        │  Tests   │ depends on -> Source + Testing
        └──────────┘
```

## Bundle ID Convention

```
com.juinjang.feature.{name}           -> Source
com.juinjang.feature.{name}.testing   -> Testing
com.juinjang.feature.{name}.tests     -> Tests
com.juinjang.feature.{name}.example   -> Example
```

## Core Module Targets

Core modules use a simpler pattern (Source + Tests):

```
Core/Dependency/   -> Interface definitions
Core/Networking/   -> Live implementations
Core/Model/        -> Domain models
Core/Common/       -> Shared utilities
```
