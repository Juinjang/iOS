# Effect Guard Patterns (isPreview)

## Principle
Even with mock dependencies, some effects may still fire unexpectedly during
Preview rendering. The `isPreview` guard provides a **defense-in-depth** layer
that short-circuits all effects when running inside Xcode Previews.

## Defining the isPreview Dependency

```swift
import Dependencies

extension DependencyValues {
    var isPreview: Bool {
        get { self[IsPreviewKey.self] }
        set { self[IsPreviewKey.self] = newValue }
    }
}

private enum IsPreviewKey: DependencyKey {
    static let liveValue: Bool =
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    static let testValue: Bool = false
}
```

Place this in `Core/Dependency/Sources/` so all feature modules can access it.

## Reducer-Level Guard

Guard effects at the **reducer level**, not at the view level. This ensures
no effect logic runs regardless of how the store is constructed.

```swift
@Reducer
struct HomeFeature {
    @Dependency(\.isPreview) var isPreview

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                guard !isPreview else { return .none }
                return .run { send in
                    let items = try await apiClient.fetchItems()
                    await send(.internal(.itemsLoaded(items)))
                }

            case .view(.refreshTapped):
                guard !isPreview else { return .none }
                state.isLoading = true
                return .run { send in
                    let items = try await apiClient.fetchItems()
                    await send(.internal(.itemsLoaded(items)))
                }

            // ...
            }
        }
    }
}
```

## When to Use the Guard

Apply `guard !isPreview else { return .none }` to actions that trigger:
- Network requests
- Disk I/O (file read/write, CoreData, Keychain)
- Analytics tracking
- Timer/scheduling effects
- Any `.run { }` block with side effects

Do **not** guard pure state mutations -- they are safe and needed for the Preview
to render correctly:

```swift
case .view(.toggleFavorite(let id)):
    // Pure state mutation -- no guard needed
    state.items[id: id]?.isFavorite.toggle()
    return .none
```

## Prefer Reducer-Level Over View-Level

```swift
// BAD - view-level guard
var body: some View {
    content
        .task {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                store.send(.view(.onAppear))
            }
        }
}

// GOOD - reducer-level guard
// View sends action normally; reducer decides whether to run effects
var body: some View {
    content
        .task {
            store.send(.view(.onAppear))
        }
}
```

The reducer-level approach keeps the view simple and the effect-guarding logic
centralized in the reducer where it belongs.

## Testing Considerations

In tests, `isPreview` defaults to `false` (via `testValue`), so all effects run
normally. No special test configuration is needed.

```swift
// In tests, isPreview is false by default -- effects run as expected
let store = TestStore(initialState: .init(), reducer: { HomeFeature() })
await store.send(.view(.onAppear))
await store.receive(.internal(.itemsLoaded(mockItems)))
```

## Related
- `preview-dependency-mock.md` - Mock dependencies (primary defense)
- `preview-principles.md` - Why effects must not run in Preview
