# TCA Interface Navigation Pattern

## Overview
The Interface Navigation pattern separates a feature's **public API** (State, Action, Path)
from its **implementation** (reducer logic). This is essential for TMA-based modular projects
where features must reference each other's types without creating circular dependencies.

## The Problem
In a modular project, FeatureA's navigation Path might include FeatureB, and FeatureB
might need to navigate to FeatureA. Direct dependencies create circular imports.

## The Solution: Injected Reduce Closure

### Step 1: Interface Target (Public API Only)

The Interface target defines the Reducer struct, State, Action, and Path,
but accepts the actual logic as an injected `Reduce<State, Action>` closure.

```swift
// FeatureHomeInterface/Sources/HomeRootFeature.swift

@Reducer
public struct HomeRootFeature {
    private let reducer: Reduce<State, Action>

    // Parameterized init - used by Interface target
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }

    @Reducer(state: .equatable)
    public enum Path {
        case postDetail(PostDetailFeature)
        case userProfile(UserProfileFeature)
    }

    @ObservableState
    public struct State: Equatable {
        public var path = StackState<Path.State>()
        public var home: HomeFeature.State

        public init(home: HomeFeature.State = .init()) {
            self.home = home
        }
    }

    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case home(HomeFeature.Action)
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case logoutRequested
        }
    }

    public var body: some Reducer<State, Action> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        reducer  // <-- injected logic runs here
            .forEach(\.path, action: \.path)
    }
}
```

### Step 2: Implementation Target (Actual Logic)

The Implementation target provides a convenience `init()` that constructs
the `Reduce` closure with actual navigation and business logic.

```swift
// FeatureHome/Sources/HomeRootFeature+Live.swift

extension HomeRootFeature {
    public init() {
        let reducer = Reduce<State, Action> { state, action in
            switch action {
            case let .home(.delegate(delegate)):
                switch delegate {
                case .postTapped(let post):
                    state.path.append(.postDetail(.init(post: post)))
                    return .none
                case .profileTapped(let userId):
                    state.path.append(.userProfile(.init(userId: userId)))
                    return .none
                }

            case let .path(.element(id: _, action: .postDetail(.delegate(delegate)))):
                switch delegate {
                case .deleted:
                    state.path.popLast()
                    return .none
                }

            case let .path(.element(id: _, action: .userProfile(.delegate(delegate)))):
                switch delegate {
                case .logoutCompleted:
                    return .send(.delegate(.logoutRequested))
                }

            default:
                return .none
            }
        }
        self.init(reducer: reducer)
    }
}
```

### Step 3: Module Dependencies

```
FeatureHomeInterface (no feature dependencies)
    ^
    |--- FeatureHome (depends on FeatureHomeInterface + child Interfaces)
    |--- FeatureLogin (can depend on FeatureHomeInterface for type references)
```

Other modules depend on the **Interface target only**, gaining access to
State/Action types without pulling in implementation details.

## Delegate Pattern for Cross-Feature Communication

Every feature communicates upward through a nested `Delegate` enum:

```swift
public enum Action {
    // ... other actions
    case delegate(Delegate)

    public enum Delegate: Equatable {
        case postTapped(Post)
        case logoutRequested
    }
}
```

Parent reducers intercept delegate actions and decide what to do:
```swift
case let .home(.delegate(.postTapped(post))):
    state.path.append(.postDetail(.init(post: post)))
    return .none
```

## Chain of Delegation

```
ChildFeature.Delegate
    -> RootFeature intercepts
        -> RootFeature.Delegate (if needed)
            -> MainTabFeature intercepts
                -> AppFeature intercepts
```

## Key Benefits
1. **No circular dependencies** - modules only depend on Interface targets
2. **Clean compilation** - changing implementation doesn't recompile dependents
3. **Testable** - inject mock `Reduce` closures in tests
4. **Type-safe navigation** - Path enum provides compile-time safety
5. **Independent development** - features can be built/tested in isolation

## When to Use
- Any feature that participates in cross-module navigation
- Root-level features managing StackState with children from different modules
- Features that need to expose types to other modules without implementation coupling
