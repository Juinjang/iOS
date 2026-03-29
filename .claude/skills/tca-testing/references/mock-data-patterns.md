# Mock Data Patterns

## Where Mocks Live

```
Feature/{Name}/Testing/Mock/Mock{Name}Data.swift
```

The `{Name}Testing` target is a `staticFramework` that depends on the main target.
Other modules' Tests can also import it for shared mock data.

## Convention: Enum with Static Properties

Use an enum (not struct) to prevent instantiation.

```swift
import Foundation
import Model

// MARK: - Mock Home Data

public enum MockHomeData {

    // MARK: - Single Items

    public static let singlePost = Post(
        id: "test_1",
        title: "Test Post",
        content: "Test content",
        authorId: "user_1",
        createdAt: Date(timeIntervalSince1970: 1_700_000_000)
    )

    public static let singleUser = User(
        id: "user_1",
        name: "Test User",
        email: "test@example.com"
    )

    // MARK: - Collections

    public static let posts: [Post] = [
        Post(
            id: "1",
            title: "First Post",
            content: "Content 1",
            authorId: "user_1",
            createdAt: Date(timeIntervalSince1970: 1_700_000_000)
        ),
        Post(
            id: "2",
            title: "Second Post",
            content: "Content 2",
            authorId: "user_2",
            createdAt: Date(timeIntervalSince1970: 1_700_000_001)
        )
    ]

    // MARK: - Edge Cases

    public static let emptyPosts: [Post] = []

    public static let largePosts: [Post] = (1...100).map { i in
        Post(
            id: "\(i)",
            title: "Post \(i)",
            content: "Content \(i)",
            authorId: "user_\(i % 5)",
            createdAt: Date(timeIntervalSince1970: 1_700_000_000 + Double(i))
        )
    }

    // MARK: - States

    public static let loadedState = HomeFeature.State(
        posts: posts,
        isLoading: false
    )

    public static let loadingState = HomeFeature.State(
        isLoading: true
    )

    public static let errorState = HomeFeature.State(
        isLoading: false,
        errorMessage: "Network error"
    )
}
```

## Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| File | `Mock{Feature}Data.swift` | `MockHomeData.swift` |
| Enum | `Mock{Feature}Data` | `MockHomeData` |
| Single item | `single{Model}` | `singlePost` |
| Collection | `{models}` (plural) | `posts` |
| Edge case | descriptive name | `emptyPosts`, `largePosts` |
| Pre-built state | `{descriptor}State` | `loadedState`, `errorState` |

## Date Handling

Use fixed timestamps for deterministic tests:

```swift
// GOOD - deterministic
Date(timeIntervalSince1970: 1_700_000_000)

// BAD - changes every run
Date()
```

## Dependency Mock Helpers

For complex dependency overrides, add helper functions:

```swift
public enum MockAPIResponses {

    public static func successFeed(_ posts: [Post] = MockHomeData.posts)
        -> @Sendable () async throws -> [Post]
    {
        { posts }
    }

    public static func failureFeed(_ error: Error = MockErrors.network)
        -> @Sendable () async throws -> [Post]
    {
        { throw error }
    }

    public static func delayedFeed(
        _ posts: [Post] = MockHomeData.posts,
        delay: Duration = .milliseconds(100)
    ) -> @Sendable () async throws -> [Post] {
        {
            try await Task.sleep(for: delay)
            return posts
        }
    }
}

public enum MockErrors {
    public static let network = NSError(domain: "test.network", code: -1)
    public static let unauthorized = NSError(domain: "test.auth", code: 401)
    public static let notFound = NSError(domain: "test.api", code: 404)
}
```

## Usage in Tests

```swift
@Test
func loadFeedSuccess() async {
    let store = TestStore(initialState: HomeFeature.State()) {
        HomeFeature()
    } withDependencies: {
        $0.apiClient.fetchHomeFeed = MockAPIResponses.successFeed()
    }
    // ...
}
```
