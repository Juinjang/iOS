# Mock Dependency Patterns for Preview

## Principle
All Preview stores **must** inject mock dependencies. Live dependencies (network,
disk, analytics) must never execute during Preview rendering.

## Pattern: .mock / .preview Static Properties

Define mock implementations as static properties on dependency client types.

```swift
extension APIClient {
    static let mock = Self(
        fetchItems: { [] },
        fetchUser: { _ in .init(id: "1", name: "Mock User") },
        createItem: { _ in .init(id: "new", title: "Created") }
    )
}
```

For clients with many endpoints, provide a `.preview` variant with minimal stubs:

```swift
extension APIClient {
    /// Minimal mock that returns empty/default values. Use for Previews
    /// where the specific endpoint response does not matter.
    static let preview = Self(
        fetchItems: { [] },
        fetchUser: { _ in .placeholder },
        createItem: { _ in .placeholder }
    )

    /// Mock with realistic sample data for Previews that display content.
    static let mock = Self(
        fetchItems: { Item.samples },
        fetchUser: { _ in .sample },
        createItem: { _ in .sample }
    )
}
```

## Using withDependencies in Preview Store

Inject mock dependencies using the `withDependencies` trailing closure on `Store.init`:

```swift
#Preview("Loaded") {
    HomeView(
        store: Store(initialState: .previewLoaded, reducer: { HomeFeature() }) {
            $0.apiClient = .mock
            $0.analyticsClient = .noop
            $0.userDefaultsClient = .noop
        }
    )
}
```

## Preview Store Factory

For features with many dependencies, create a factory to avoid repetition:

```swift
enum PreviewStoreFactory {
    static func home(state: HomeFeature.State = .previewLoaded) -> StoreOf<HomeFeature> {
        Store(initialState: state, reducer: { HomeFeature() }) {
            $0.apiClient = .mock
            $0.analyticsClient = .noop
            $0.userDefaultsClient = .noop
        }
    }

    static func profile(state: ProfileFeature.State = .previewLoaded) -> StoreOf<ProfileFeature> {
        Store(initialState: state, reducer: { ProfileFeature() }) {
            $0.apiClient = .mock
            $0.authClient = .mock
            $0.analyticsClient = .noop
        }
    }
}
```

Usage:

```swift
#Preview("Loaded") {
    HomeView(store: PreviewStoreFactory.home())
}

#Preview("Empty") {
    HomeView(store: PreviewStoreFactory.home(state: .previewEmpty))
}
```

## Noop Pattern for Side-Effect-Only Clients

For clients that only produce side effects (analytics, logging), use `.noop`:

```swift
extension AnalyticsClient {
    static let noop = Self(
        track: { _ in },
        identify: { _ in }
    )
}
```

## Rules
1. **Every** dependency referenced by the reducer must be mocked in the Preview store
2. Mock closures should return **synchronously** -- no `Task.sleep` or async delays
3. Mock data should be **consistent** with the preview state (do not return items
   if the state says `isLoading: true`)
4. Use `.noop` for fire-and-forget clients (analytics, logging)
5. Place mock definitions in the same file as the dependency client, or in a
   dedicated `{Client}+Mock.swift` file within the module

## Related
- `preview-state-patterns.md` - Defining preview states
- `preview-effect-guard.md` - Additional safety via isPreview guard
