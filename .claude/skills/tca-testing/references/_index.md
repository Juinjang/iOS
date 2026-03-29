# TCA Testing Quick Reference

## Testing Stack
- Swift Testing (`@Test`, `#expect`, `@MainActor struct`)
- TCA `TestStore` for reducer testing
- `withDependencies` for dependency injection in tests

## Current Test Coverage

| Module | Tests | Mocks | Status |
|--------|-------|-------|--------|
| Feature/Home | 2 tests (success + failure) | MockHomeData.posts | Most complete |
| Feature/Splash | 1 test (onAppear) | Placeholder | Basic |
| Feature/Onboarding | 1 test (onAppear) | Placeholder | Basic |
| Feature/Login | 1 test (onAppear) | Placeholder | Basic |
| Core/Dependency | None | N/A | No test target |
| Core/Networking | None | N/A | No test target |
| Core/Model | None | N/A | No test target |
| Core/Common | None | N/A | No test target |

## Test File Conventions

### Test File
```
Feature/{Name}/Tests/{Name}FeatureTests.swift
```
```swift
import ComposableArchitecture
import Model
import Testing
@testable import {Name}
@testable import {Name}Testing

@MainActor
struct {Name}FeatureTests {
    @Test
    func testSomething() async {
        // ...
    }
}
```

### Mock File
```
Feature/{Name}/Testing/Mock/Mock{Name}Data.swift
```
```swift
import Foundation
import Model

public enum Mock{Name}Data {
    public static let items: [Item] = [ ... ]
}
```

## Reference Files

| File | Topic |
|------|-------|
| `feature-test-patterns.md` | Reducer action/effect/delegate testing |
| `mock-data-patterns.md` | Mock data conventions |
| `core-module-testing.md` | Adding tests to Core modules |
| `navigation-testing.md` | StackState navigation tests |
| `test-checklist.md` | Per-feature test checklist |
