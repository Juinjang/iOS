# TCA Effects

## Effect Types

### No Effect
```swift
return .none
```

### Async Effect with .run
```swift
return .run { send in
    let result = try await apiClient.fetchHomeFeed()
    await send(.postsLoaded(.success(result)))
} catch: { error, send in
    await send(.postsLoaded(.failure(error)))
}
```

### Send Action Immediately
```swift
return .send(.delegate(.didComplete))
```

### Concatenate Effects (Sequential)
```swift
return .concatenate(
    .send(.startLoading),
    .run { send in
        let data = try await apiClient.fetch()
        await send(.dataLoaded(data))
    }
)
```

### Merge Effects (Parallel)
```swift
return .merge(
    .run { send in
        let posts = try await apiClient.fetchPosts()
        await send(.postsLoaded(posts))
    },
    .run { send in
        let user = try await apiClient.fetchUser()
        await send(.userLoaded(user))
    }
)
```

## Cancellation

### Cancel by ID
```swift
enum CancelID { case search }

// Start cancellable effect
return .run { send in
    let results = try await apiClient.search(query)
    await send(.searchResults(results))
}
.cancellable(id: CancelID.search, cancelInFlight: true)

// Cancel explicitly
return .cancel(id: CancelID.search)
```

### Debouncing
```swift
case let .searchQueryChanged(query):
    state.searchQuery = query
    return .run { send in
        try await Task.sleep(for: .milliseconds(300))
        let results = try await apiClient.search(query)
        await send(.searchResults(results))
    }
    .cancellable(id: CancelID.search, cancelInFlight: true)
```

## Timer / Long-Running Effects

```swift
return .run { send in
    for await _ in clock.timer(interval: .seconds(1)) {
        await send(.timerTicked)
    }
}
.cancellable(id: CancelID.timer)
```

## Publisher-Based Effects (Legacy Bridge)

```swift
return .publisher {
    NotificationCenter.default
        .publisher(for: UIApplication.didBecomeActiveNotification)
        .map { _ in .appBecameActive }
}
```
