# TCA Dependencies

## @Dependency Property Wrapper

```swift
@Reducer
struct HomeFeature {
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.uuid) var uuid
    @Dependency(\.date) var date

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let posts = try await apiClient.fetchHomeFeed()
                    await send(.postsLoaded(.success(posts)))
                }
            // ...
            }
        }
    }
}
```

## Defining a Dependency Client

### Closure-Based Client (Recommended)

```swift
// Interface: Core/Dependency/Sources/APIClient.swift
@DependencyClient
public struct APIClient {
    public var fetchHomeFeed: @Sendable () async throws -> [Post]
    public var fetchUserProfile: @Sendable (_ userId: String) async throws -> User
}

extension APIClient: TestDependencyKey {
    public static let testValue = Self()  // auto-generates unimplemented
}

extension DependencyValues {
    public var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
```

### Live Implementation

```swift
// Core/Networking/Sources/APIClientLive.swift
extension APIClient: DependencyKey {
    public static let liveValue: APIClient = {
        let client = NetworkClient()

        return Self(
            fetchHomeFeed: {
                let response: ResultResponse<[Post]> = try await client.request(
                    HomeAPI.fetchFeed,
                    responseType: ResultResponse<[Post]>.self
                )
                return try APIMapper.mapData(response, transform: { $0 })
            },
            fetchUserProfile: { userId in
                let response: ResultResponse<User> = try await client.request(
                    UserAPI.fetchProfile(userId: userId),
                    responseType: ResultResponse<User>.self
                )
                return try APIMapper.mapData(response, transform: { $0 })
            }
        )
    }()
}
```

## Key Patterns

### Memberwise Init (Preferred)
```swift
return APIClient(
    fetchHomeFeed: { ... },
    fetchUserProfile: { ... }
)
```
- Immutable, all properties set at once
- Compiler catches missing properties

### @DependencyClient Macro
- Auto-generates `unimplemented` defaults for `testValue`
- Triggers XCTest failure if called without override in tests

## Project-Specific Module Layout

```
Core/Dependency  -> APIClient interface (@DependencyClient, TestDependencyKey)
Core/Networking  -> APIClient live implementation (DependencyKey, liveValue)
Feature/*        -> Consumes via @Dependency(\.apiClient)
```

## Overriding in Tests

```swift
let store = TestStore(initialState: HomeFeature.State()) {
    HomeFeature()
} withDependencies: {
    $0.apiClient.fetchHomeFeed = { [Post.mock] }
}
```

## Overriding in Previews

```swift
#Preview {
    HomeView(
        store: Store(initialState: HomeFeature.State()) {
            HomeFeature()
        } withDependencies: {
            $0.apiClient.fetchHomeFeed = { Post.previews }
        }
    )
}
```
