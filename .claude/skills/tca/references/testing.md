# TCA Testing

## TestStore Basics

```swift
@Test
func testOnAppear() async {
    let store = TestStore(initialState: HomeFeature.State()) {
        HomeFeature()
    } withDependencies: {
        $0.apiClient.fetchHomeFeed = { [Post.mock] }
    }

    await store.send(.onAppear) {
        $0.isLoading = true
    }

    await store.receive(\.postsLoaded.success) {
        $0.isLoading = false
        $0.posts = [Post.mock]
    }
}
```

## Exhaustive vs Non-Exhaustive Testing

### Exhaustive (Default)
Every state change and received action must be asserted.

### Non-Exhaustive
Skip assertions for intermediate steps:
```swift
store.exhaustivity = .off(showSkippedAssertions: true)

await store.send(.onAppear)
await store.receive(\.postsLoaded)

store.assert {
    $0.posts = [Post.mock]
}
```

## Testing Navigation (StackState)

```swift
@Test
func testNavigateToDetail() async {
    let store = TestStore(initialState: HomeRootFeature.State()) {
        HomeRootFeature()
    }

    await store.send(.home(.delegate(.postTapped(Post.mock)))) {
        $0.path[id: 0] = .detail(PostDetailFeature.State(post: .mock))
    }
}
```

## Testing Effects

```swift
@Test
func testErrorHandling() async {
    let store = TestStore(initialState: HomeFeature.State()) {
        HomeFeature()
    } withDependencies: {
        $0.apiClient.fetchHomeFeed = { throw APIError.networkError }
    }

    await store.send(.onAppear) {
        $0.isLoading = true
    }

    await store.receive(\.postsLoaded.failure) {
        $0.isLoading = false
        $0.errorMessage = "Network error"
    }
}
```

## Testing Delegate Actions

```swift
@Test
func testDelegateAction() async {
    let store = TestStore(initialState: ChildFeature.State()) {
        ChildFeature()
    }

    await store.send(.deleteTapped)
    await store.receive(\.delegate.didDelete)
}
```

## Clock Testing

```swift
@Test
func testTimer() async {
    let clock = TestClock()

    let store = TestStore(initialState: TimerFeature.State()) {
        TimerFeature()
    } withDependencies: {
        $0.continuousClock = clock
    }

    await store.send(.startTimer)
    await clock.advance(by: .seconds(1))
    await store.receive(\.timerTicked) {
        $0.secondsElapsed = 1
    }
}
```
