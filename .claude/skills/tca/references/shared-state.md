# TCA Shared State

## @Shared Property Wrapper

Share state across multiple features without parent-child coupling.

### In-Memory Shared State
```swift
@ObservableState
struct State: Equatable {
    @Shared(.inMemory("currentUser")) var currentUser: User?
}
```

### AppStorage (UserDefaults)
```swift
@ObservableState
struct State: Equatable {
    @Shared(.appStorage("hasSeenOnboarding")) var hasSeenOnboarding: Bool = false
    @Shared(.appStorage("selectedTheme")) var selectedTheme: String = "light"
}
```

### FileStorage
```swift
@ObservableState
struct State: Equatable {
    @Shared(.fileStorage(.documentsDirectory.appending(path: "favorites.json")))
    var favorites: [Post] = []
}
```

## Mutating Shared State

```swift
case .toggleFavorite(let post):
    state.$favorites.withLock { favorites in
        if let index = favorites.firstIndex(of: post) {
            favorites.remove(at: index)
        } else {
            favorites.append(post)
        }
    }
    return .none
```

## Key Rules
1. Use `$property.withLock { }` for mutations (thread-safe)
2. Multiple features can read/write the same `@Shared` key
3. Changes propagate automatically across all subscribers
4. `@Shared` supports `Equatable` checking for test assertions
