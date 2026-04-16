# TCA Reducer Composition

## Scope - Embed Child in Parent

```swift
@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        var child: ChildFeature.State = .init()
        var otherChild: OtherFeature.State = .init()
    }

    enum Action {
        case child(ChildFeature.Action)
        case otherChild(OtherFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.child, action: \.child) {
            ChildFeature()
        }
        Scope(state: \.otherChild, action: \.otherChild) {
            OtherFeature()
        }
        Reduce { state, action in
            // Parent-level logic (runs after child reducers)
            switch action {
            case .child(.delegate(.didComplete)):
                // React to child delegate
                return .none
            default:
                return .none
            }
        }
    }
}
```

## ifLet - Optional Child State (Sheets, Alerts)

```swift
var body: some ReducerOf<Self> {
    Reduce { state, action in
        // core logic
    }
    .ifLet(\.$sheet, action: \.sheet) {
        SheetFeature()
    }
    .ifLet(\.$alert, action: \.alert)
}
```

## forEach - Collection of Children (StackState, IdentifiedArray)

### StackState Navigation
```swift
var body: some ReducerOf<Self> {
    Reduce { state, action in
        // navigation logic
    }
    .forEach(\.path, action: \.path)
}
```

### IdentifiedArray of Children
```swift
@ObservableState
struct State: Equatable {
    var items: IdentifiedArrayOf<ItemFeature.State> = []
}

enum Action {
    case items(IdentifiedActionOf<ItemFeature>)
}

var body: some ReducerOf<Self> {
    Reduce { state, action in
        // ...
    }
    .forEach(\.items, action: \.items) {
        ItemFeature()
    }
}
```

## Composition Order

```swift
var body: some ReducerOf<Self> {
    // 1. Child scopes first
    Scope(state: \.child, action: \.child) { ChildFeature() }

    // 2. Core reducer (can react to child delegates)
    Reduce { state, action in
        // ...
    }

    // 3. forEach / ifLet after Reduce
    .forEach(\.path, action: \.path)
    .ifLet(\.$sheet, action: \.sheet) { SheetFeature() }
}
```

**Important**: `Scope` runs before `Reduce`, so child reducers process first.
`forEach` and `ifLet` are chained on `Reduce`, running as part of the parent reducer.

## Tab-Based Composition (MainTab)

```swift
@Reducer
struct MainTabFeature {
    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .home
        var homeRoot: HomeRootFeature.State = .init()
        var myPageRoot: MyPageRootFeature.State = .init()
    }

    enum Action {
        case tabSelected(Tab)
        case homeRoot(HomeRootFeature.Action)
        case myPageRoot(MyPageRootFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.homeRoot, action: \.homeRoot) {
            HomeRootFeature()
        }
        Scope(state: \.myPageRoot, action: \.myPageRoot) {
            MyPageRootFeature()
        }
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
            default:
                return .none
            }
        }
    }
}
```
