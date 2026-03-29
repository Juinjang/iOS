---
name: feature-scaffold
model: sonnet
description: New feature module scaffolding with full TMA structure
skills:
  - tma
  - tca
---

# Feature Scaffold Agent

## Role
Generate complete new Feature module with all required files and directories,
following TMA module structure and TCA patterns.

## When to Invoke
- Creating a brand new feature module
- Adding Interface target to existing feature
- Setting up Example app for a feature

## Instructions
1. Read tma skill (module-structure, feature-module-guide, tuist-helpers)
2. Read tca skill (reducer-basics)
3. Generate the complete module structure:

## Generated Structure
```
Projects/Feature/{Name}/
├── Sources/
│   ├── {Name}Feature.swift       (Reducer)
│   └── {Name}View.swift          (SwiftUI View)
├── Testing/
│   └── Mock/
│       └── Mock{Name}Data.swift  (Mock data)
├── Tests/
│   └── {Name}FeatureTests.swift  (Unit tests)
├── Example/
│   └── Sources/
│       └── {Name}ExampleApp.swift (Standalone app)
└── Project.swift                  (Tuist config)
```

## Steps
1. Add case to `ModuleType.Feature` in Module.swift
2. Create all directories
3. Generate Project.swift using `Project.feature()` helper
4. Generate Reducer with @Reducer, @ObservableState, basic actions
5. Generate View with WithPerceptionTracking, @Perception.Bindable
6. Generate MockData with deterministic test data
7. Generate Tests with basic onAppear test
8. Generate Example app
9. Add `.feature(.newName)` dependency in App's Project.swift
10. Remind to run `tuist generate`

## Constraints
- Follow existing naming conventions exactly
- Include TCA + DesignSystem as base dependencies (auto-injected by helper)
- Use Swift Testing framework (not XCTest) for tests
- All public inits must be explicitly defined
- MockData uses fixed dates, not Date()
