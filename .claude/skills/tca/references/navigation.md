# TCA Navigation (StackState)

## StackState Navigation (Push/Pop)

The primary navigation pattern for drill-down flows. Each tab/root manages its own stack.

### Defining the Path

```swift
@Reducer
struct HomeRootFeature {

    @Reducer(state: .equatable)
    enum Path {
        case detail(PostDetailFeature)
        case editProfile(EditProfileFeature)
        case settings(SettingsFeature)
    }

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var home: HomeFeature.State = .init()
    }

    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case home(HomeFeature.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Reduce { state, action in
            switch action {
            case .home(.postTapped(let post)):
                state.path.append(.detail(.init(post: post)))
                return .none

            case .path(.element(id: _, action: .detail(.delegate(.editTapped)))):
                state.path.append(.editProfile(.init()))
                return .none

            case .path(.popFrom(id: _)):
                return .none

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
```

### View with NavigationStack

```swift
struct HomeRootView: View {
    @Bindable var store: StoreOf<HomeRootFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            HomeView(store: store.scope(state: \.home, action: \.home))
        } destination: { store in
            switch store.case {
            case let .detail(store):
                PostDetailView(store: store)
            case let .editProfile(store):
                EditProfileView(store: store)
            case let .settings(store):
                SettingsView(store: store)
            }
        }
    }
}
```

## Key Navigation Actions

```swift
// Push
state.path.append(.detail(.init(post: post)))

// Pop last
state.path.popLast()

// Pop to root
state.path.removeAll()

// Pop to specific index
state.path.removeLast(state.path.count - targetIndex)
```

## Handling Child Delegate Actions

Use pattern matching on `StackAction` to intercept child actions:

```swift
case let .path(.element(id: id, action: .detail(.delegate(delegate)))):
    switch delegate {
    case .didDelete:
        state.path.popLast()
        return .none
    }
```

## Tree-Based Navigation (Sheets/Covers)

For modals and sheets, use optional state with `@Presents`:

```swift
@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        @Presents var sheet: ChildFeature.State?
    }

    enum Action {
        case alert(PresentationAction<Alert>)
        case sheet(PresentationAction<ChildFeature.Action>)

        @CasePathable
        enum Alert: Equatable {
            case confirmDelete
        }
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            // ...
        }
        .ifLet(\.$sheet, action: \.sheet) {
            ChildFeature()
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
```

## Root-Level Navigation (App Coordinator)

For switching between major app states (splash, login, main tab):

```swift
@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var splash: SplashFeature.State?
        var login: LoginFeature.State?
        var mainTab: MainTabFeature.State?
    }

    // Use ifLet for each optional child
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            // transition logic
        }
        .ifLet(\.splash, action: \.splash) { SplashFeature() }
        .ifLet(\.login, action: \.login) { LoginFeature() }
        .ifLet(\.mainTab, action: \.mainTab) { MainTabFeature() }
    }
}
```
