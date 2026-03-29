# Per-Feature Test Checklist

Use this checklist when writing tests for a new or existing feature.

## Reducer Tests

### State Mutations
- [ ] Initial state is correct
- [ ] Each user-facing action mutates state correctly
- [ ] Loading states toggle on/off properly
- [ ] Error states are set and cleared properly

### Effects (Async)
- [ ] Success path: API call succeeds, state updates with data
- [ ] Failure path: API call throws, state shows error
- [ ] Loading indicator: true before request, false after response
- [ ] Cancel in-flight: new request cancels previous one (if applicable)

### Delegate Actions
- [ ] Feature emits correct delegate actions for parent
- [ ] Delegate actions carry correct payload
- [ ] No unintended delegate emissions

### Navigation
- [ ] Push: correct child state appended to path
- [ ] Pop: child removed from path on dismiss/back
- [ ] Sheet: presented and dismissed correctly
- [ ] Alert: shown with correct message, actions handled
- [ ] Deep link: navigates to correct nested screen (if applicable)

### Bindings
- [ ] Binding changes trigger correct side effects
- [ ] Validated fields reject invalid input
- [ ] Form state resets on dismiss (if applicable)

### Edge Cases
- [ ] Empty data (no posts, no results)
- [ ] Single item
- [ ] Large dataset
- [ ] Rapid repeated actions (double tap)
- [ ] Network timeout

## Mock Data Requirements

### Testing/ Directory
- [ ] `Mock{Feature}Data.swift` exists
- [ ] Single item mock (deterministic, fixed date)
- [ ] Collection mock (2+ items)
- [ ] Empty collection mock
- [ ] Pre-built State mocks (loaded, loading, error)
- [ ] No `Date()` - use fixed timestamps

## File Structure Verification

```
Feature/{Name}/
├── Tests/
│   └── {Name}FeatureTests.swift
│       - imports: ComposableArchitecture, Model, Testing
│       - @testable import {Name}
│       - @testable import {Name}Testing
│       - @MainActor struct
│       - @Test func methods
├── Testing/
│   └── Mock/
│       └── Mock{Name}Data.swift
│           - public enum Mock{Name}Data
│           - static properties for test data
└── Example/
    └── Sources/
        └── {Name}ExampleApp.swift
```

## Minimum Test Coverage Per Feature

| Priority | What to Test | Required |
|----------|-------------|----------|
| P0 | Happy path (main flow succeeds) | Yes |
| P0 | Error path (main flow fails) | Yes |
| P1 | Delegate actions emitted correctly | Yes |
| P1 | Navigation push/pop | Yes (if has navigation) |
| P2 | Edge cases (empty, large data) | Recommended |
| P2 | Binding validation | Recommended (if has forms) |
| P3 | Timer / clock behavior | If applicable |
| P3 | Cancellation | If applicable |
