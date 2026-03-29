# TCA Reducer Basics (1.24.1+)

## @Reducer Macro

The `@Reducer` macro automatically generates conformance and composition boilerplate.

```swift
@Reducer
struct HomeFeature {

    @ObservableState
    struct State: Equatable {
        var posts: [Post] = []
        var isLoading: Bool = false
    }

    enum Action {
        case onAppear
        case postsLoaded(Result<[Post], Error>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    // async work
                }
            case let .postsLoaded(.success(posts)):
                state.isLoading = false
                state.posts = posts
                return .none
            case .postsLoaded(.failure):
                state.isLoading = false
                return .none
            }
        }
    }
}
```

## Key Rules

1. **State** must be `Equatable` and annotated with `@ObservableState`
2. **Action** is a plain enum (no conformance needed with `@Reducer` macro)
3. **body** returns `some ReducerOf<Self>` and contains reducer composition
4. Use `Reduce { state, action in }` for the core logic
5. Return `.none` when no side effects are needed
6. Return `.run { send in }` for async effects

## View Integration

```swift
struct HomeView: View {
    @Perception.Bindable var store: StoreOf<HomeFeature>

    var body: some View {
        WithPerceptionTracking {
            List(store.posts) { post in
                PostRow(post: post)
            }
            .onAppear { store.send(.onAppear) }
        }
    }
}
```

## Important Notes
- Use `WithPerceptionTracking` in view body for observation
- Use `@Perception.Bindable` (not SwiftUI `@Bindable`) for store bindings
- `StoreOf<Feature>` is a typealias for `Store<Feature.State, Feature.Action>`
