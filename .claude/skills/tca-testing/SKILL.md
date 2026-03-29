---
name: tca-testing
description: TCA test writing skill tailored to Juinjang iOS project structure
version: 1.0.0
---

# TCA Testing Skill (Project-Specific)

## Overview
Guide for writing tests in the Juinjang iOS modular project.
Covers Feature reducer tests, Core module tests, mock data patterns,
and navigation testing — all aligned with the current Tuist module structure.

## Testing Stack
- **Framework**: Swift Testing (`import Testing`, `@Test` macro)
- **TCA Testing**: `TestStore` from ComposableArchitecture
- **NOT XCTest**: Use `@Test` / `#expect` / `@MainActor struct`, NOT `XCTestCase`

## Where Tests Live

### Feature Modules (already configured)
```
Feature/{Name}/
├── Tests/           -> {Name}Tests target (unit tests)
├── Testing/Mock/    -> {Name}Testing target (mock data, stubs)
└── Example/Sources/ -> {Name}Example target (standalone demo app)
```

### Core Modules (need test target addition)
```
Core/{Name}/
├── Sources/         -> existing
├── Tests/           -> needs to be added to Project+Core.swift
└── Testing/         -> needs to be added to Project+Core.swift
```

## When to Use
- Writing new reducer tests for any Feature
- Creating mock data for Testing targets
- Adding test infrastructure to Core modules
- Testing navigation flows (StackState)
- Testing dependency client behavior

## References
- `_index.md` - Quick reference and current test coverage status
- `feature-test-patterns.md` - Reducer test patterns (actions, effects, delegates)
- `mock-data-patterns.md` - MockData conventions for Testing targets
- `core-module-testing.md` - How to add tests to Core modules
- `navigation-testing.md` - StackState navigation test patterns
- `test-checklist.md` - Per-feature test checklist template
