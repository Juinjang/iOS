# Navigation Testing Patterns

## Testing StackState Push

```swift
@Test
func navigateToDetail() async {
    let post = MockHomeData.singlePost
    let store = TestStore(
        initialState: HomeRootFeature.State(
            home: .init(posts: [post])
        )
    ) {
        HomeRootFeature()
    }

    await store.send(.home(.delegate(.postSelected(post)))) {
        $0.path[id: 0] = .detail(PostDetailFeature.State(post: post))
    }
}
```

## Testing StackState Pop

```swift
@Test
func popFromDetail() async {
    let store = TestStore(
        initialState: HomeRootFeature.State(
            path: StackState([
                .detail(PostDetailFeature.State(post: MockHomeData.singlePost))
            ])
        )
    ) {
        HomeRootFeature()
    }

    await store.send(.path(.element(id: 0, action: .detail(.delegate(.dismissed))))) {
        $0.path = StackState()
    }
}
```

## Testing Multi-Step Navigation

```swift
@Test
func pushThenPushThenPop() async {
    let store = TestStore(
        initialState: HomeRootFeature.State()
    ) {
        HomeRootFeature()
    }
    store.exhaustivity = .off(showSkippedAssertions: true)

    // Push first screen
    await store.send(.home(.delegate(.postSelected(MockHomeData.singlePost)))) {
        $0.path[id: 0] = .detail(PostDetailFeature.State(post: MockHomeData.singlePost))
    }

    // Push second screen from detail
    await store.send(.path(.element(id: 0, action: .detail(.delegate(.editTapped))))) {
        $0.path[id: 1] = .editProfile(EditProfileFeature.State())
    }

    // Pop back
    await store.send(.path(.popFrom(id: 1))) {
        $0.path[id: 1] = nil
    }
}
```

## Testing Delegate Bubbling Through Navigation

```swift
@Test
func childDelegateBubblesToRoot() async {
    let store = TestStore(
        initialState: HomeRootFeature.State(
            path: StackState([
                .detail(PostDetailFeature.State(post: MockHomeData.singlePost))
            ])
        )
    ) {
        HomeRootFeature()
    }

    // Child sends delegate action
    await store.send(
        .path(.element(id: 0, action: .detail(.delegate(.logoutRequested))))
    )

    // Root re-emits as its own delegate
    await store.receive(\.delegate.logoutRequested)
}
```

## Testing Sheet Presentation (Tree-Based)

```swift
@Test
func presentSheet() async {
    let store = TestStore(
        initialState: HomeFeature.State()
    ) {
        HomeFeature()
    }

    await store.send(.view(.filterTapped)) {
        $0.sheet = FilterFeature.State()
    }
}

@Test
func dismissSheet() async {
    let store = TestStore(
        initialState: HomeFeature.State(
            sheet: FilterFeature.State()
        )
    ) {
        HomeFeature()
    }

    await store.send(.sheet(.dismiss)) {
        $0.sheet = nil
    }
}
```

## Testing Alert

```swift
@Test
func showDeleteAlert() async {
    let store = TestStore(
        initialState: HomeFeature.State()
    ) {
        HomeFeature()
    }

    await store.send(.view(.deleteTapped)) {
        $0.alert = AlertState {
            TextState("Delete?")
        } actions: {
            ButtonState(role: .destructive, action: .confirmDelete) {
                TextState("Delete")
            }
        }
    }
}

@Test
func confirmDelete() async {
    let store = TestStore(
        initialState: HomeFeature.State(
            alert: AlertState { TextState("Delete?") }
        )
    ) {
        HomeFeature()
    }

    await store.send(.alert(.presented(.confirmDelete))) {
        $0.alert = nil
    }
}
```

## Testing Root-Level Navigation (AppFeature)

```swift
@Test
func splashCompletesNavigatesToLogin() async {
    let store = TestStore(
        initialState: AppFeature.State(
            splash: SplashFeature.State()
        )
    ) {
        AppFeature()
    }

    await store.send(.splash(.delegate(.completed))) {
        $0.splash = nil
        $0.login = LoginFeature.State()
    }
}

@Test
func loginSuccessNavigatesToMainTab() async {
    let store = TestStore(
        initialState: AppFeature.State(
            login: LoginFeature.State()
        )
    ) {
        AppFeature()
    }

    await store.send(.login(.delegate(.loginCompleted))) {
        $0.login = nil
        $0.mainTab = MainTabFeature.State()
    }
}
```
