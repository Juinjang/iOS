# Preview State Patterns

## Principle
Preview state must be **pre-populated and deterministic**. Never rely on effects,
reducers, or async operations to build the state that a Preview displays.

## Pattern: static let on Feature.State Extension

Define preview states as `static let` properties in an extension on `Feature.State`.
Each property represents a distinct visual variant of the view.

```swift
extension HomeFeature.State {
    static let previewLoaded = Self(
        items: [
            .init(id: 1, title: "Sample Item 1"),
            .init(id: 2, title: "Sample Item 2"),
            .init(id: 3, title: "Sample Item 3"),
        ],
        isLoading: false
    )

    static let previewEmpty = Self(
        items: [],
        isLoading: false
    )

    static let previewLoading = Self(
        items: [],
        isLoading: true
    )

    static let previewError = Self(
        items: [],
        isLoading: false,
        errorMessage: "Failed to load items"
    )
}
```

## Naming Convention
Use the `preview` prefix followed by the variant name:
- `previewLoaded` - normal state with data
- `previewEmpty` - empty state (no data)
- `previewLoading` - loading / skeleton state
- `previewError` - error state with message

## Usage in #Preview

```swift
#Preview("Loaded") {
    HomeView(
        store: Store(initialState: .previewLoaded, reducer: { HomeFeature() }) {
            $0.apiClient = .mock
        }
    )
}

#Preview("Empty") {
    HomeView(
        store: Store(initialState: .previewEmpty, reducer: { HomeFeature() }) {
            $0.apiClient = .mock
        }
    )
}

#Preview("Loading") {
    HomeView(
        store: Store(initialState: .previewLoading, reducer: { HomeFeature() }) {
            $0.apiClient = .mock
        }
    )
}
```

## Rules
1. **Never** call `store.send(.view(.onAppear))` or similar actions to build state
2. **Never** use `@State` or `@StateObject` in Preview for TCA-managed data
3. States must contain **realistic sample data** (not empty strings or zero values)
4. Include **all required nested state** -- if a child feature state is part of the parent,
   provide it fully populated
5. Keep sample data **small but representative** -- 3-5 items for lists is sufficient

## Complex Nested State Example

```swift
extension ProfileFeature.State {
    static let previewLoaded = Self(
        user: .init(
            id: "user-1",
            name: "Preview User",
            avatarURL: nil
        ),
        settings: .init(
            notificationsEnabled: true,
            darkMode: false
        ),
        isLoading: false
    )
}
```

## Related
- `preview-principles.md` - Core principles
- `preview-dependency-mock.md` - Pairing states with mock dependencies
