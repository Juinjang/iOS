# Feature Reducer Test Patterns

## Basic TestStore Setup

```swift
import ComposableArchitecture
import Model
import Testing
@testable import Home
@testable import HomeTesting

@MainActor
struct HomeFeatureTests {

    // Helper: create store with common dependencies
    private func makeStore(
        state: HomeFeature.State = .init(),
        fetchHomeFeed: @Sendable @escaping () async throws -> [Post] = { [] }
    ) -> TestStore<HomeFeature.State, HomeFeature.Action> {
        TestStore(initialState: state) {
            HomeFeature()
        } withDependencies: {
            $0.apiClient.fetchHomeFeed = fetchHomeFeed
        }
    }
}
```

## Pattern 1: Action -> State Mutation

Test that sending an action correctly mutates state.

```swift
@Test
func onAppearSetsLoading() async {
    let store = makeStore(fetchHomeFeed: { MockHomeData.posts })

    await store.send(.view(.onAppear)) {
        $0.isLoading = true
        $0.errorMessage = nil
    }

    await store.receive(\.feedResponse.success) {
        $0.isLoading = false
        $0.posts = MockHomeData.posts
    }
}
```

## Pattern 2: Error Handling

Test that errors are properly caught and state reflects the failure.

```swift
@Test
func onAppearHandlesNetworkError() async {
    let store = makeStore(fetchHomeFeed: {
        throw NSError(domain: "test", code: -1)
    })

    await store.send(.view(.onAppear)) {
        $0.isLoading = true
        $0.errorMessage = nil
    }

    await store.receive(\.feedResponse.failure) {
        $0.isLoading = false
        $0.errorMessage = "The operation couldn't be completed. (test error -1.)"
    }
}
```

## Pattern 3: Delegate Actions

Test that a feature emits delegate actions for parent to handle.

```swift
@Test
func postTapEmitsDelegate() async {
    let post = MockHomeData.posts[0]
    let store = TestStore(
        initialState: HomeFeature.State(posts: [post])
    ) {
        HomeFeature()
    }

    await store.send(.view(.postTapped(post)))
    await store.receive(\.delegate.postSelected)
}
```

## Pattern 4: Binding Changes

Test that binding mutations trigger expected side effects.

```swift
@Test
func searchQueryTriggersFilter() async {
    let store = makeStore()
    store.exhaustivity = .off

    await store.send(.binding(.set(\.searchQuery, "test")))

    // Assert filtered state
    store.assert {
        $0.searchQuery = "test"
    }
}
```

## Pattern 5: Effect Cancellation

Test that in-flight effects are cancelled when needed.

```swift
@Test
func newSearchCancelsPrevious() async {
    let store = makeStore()
    store.exhaustivity = .off(showSkippedAssertions: false)

    await store.send(.view(.searchQueryChanged("a")))
    await store.send(.view(.searchQueryChanged("ab")))  // cancels first

    // Only second search result should arrive
    await store.receive(\.searchResults)
}
```

## Pattern 5: Non-Exhaustive Testing

When you only care about the final state, not every intermediate step.

```swift
@Test
func fullFlowEndState() async {
    let store = makeStore(fetchHomeFeed: { MockHomeData.posts })
    store.exhaustivity = .off(showSkippedAssertions: true)

    await store.send(.view(.onAppear))
    await store.receive(\.feedResponse)

    store.assert {
        $0.isLoading = false
        $0.posts = MockHomeData.posts
    }
}
```

## Pattern 6: Clock / Timer Testing

```swift
@Test
func autoRefreshTimerTicks() async {
    let clock = TestClock()
    let store = TestStore(initialState: HomeFeature.State()) {
        HomeFeature()
    } withDependencies: {
        $0.continuousClock = clock
        $0.apiClient.fetchHomeFeed = { MockHomeData.posts }
    }

    await store.send(.view(.startAutoRefresh))
    await clock.advance(by: .seconds(30))
    await store.receive(\.timerTicked)
}
```

## Assertions Cheat Sheet

| Swift Testing | Purpose |
|--------------|---------|
| `#expect(value == expected)` | Equality check |
| `#expect(value != nil)` | Non-nil check |
| `#expect(throws: SomeError.self)` | Error thrown |
| `#expect(array.isEmpty)` | Collection empty |
| `#expect(array.count == 3)` | Collection count |

## Key Rules

1. Always use `@MainActor` on test structs (TCA requirement)
2. Use `async` on all test methods that interact with TestStore
3. Assert ALL state changes in `store.send` closure (exhaustive by default)
4. Assert ALL received actions with `store.receive`
5. Use `store.exhaustivity = .off` only when testing high-level flows
6. Always inject dependencies via `withDependencies`
7. Never use real network calls in tests - always mock
