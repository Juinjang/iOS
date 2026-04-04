# TCA 패턴 통일 규칙

## 바인딩 — @Bindable (통일)

iOS 17+ / TCA 1.7+ 환경에서는 SwiftUI 네이티브 `@Bindable`을 사용합니다.

```swift
// ✅ 올바른 패턴
@Bindable var store: StoreOf<MyFeature>

// ❌ 사용 금지 — iOS 16 하위 호환용이므로 이 프로젝트에서 불필요
@Perception.Bindable var store: StoreOf<MyFeature>
```

## WithPerceptionTracking — 불필요

iOS 17+에서는 `@Observable` 매크로가 네이티브로 지원되므로
`WithPerceptionTracking`으로 View body를 감쌀 필요가 없습니다.

```swift
// ✅ 올바른 패턴
public var body: some View {
    VStack {
        Text(store.title)
    }
}

// ❌ 사용 금지 — iOS 16 하위 호환용
public var body: some View {
    WithPerceptionTracking {
        VStack {
            Text(store.title)
        }
    }
}
```

## Reducer 구조

```swift
@Reducer
public struct MyFeature: Sendable {
    @ObservableState
    public struct State: Equatable {
        // ...
        public init() {}
    }

    public enum Action {
        case view(View)
        case delegate(Delegate)

        public enum View: Equatable { ... }
        public enum Delegate: Equatable { ... }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view: ...
            case .delegate: return .none
            }
        }
    }
}
```

## View 구조

```swift
public struct MyView: View {
    @Bindable var store: StoreOf<MyFeature>

    public init(store: StoreOf<MyFeature>) {
        self.store = store
    }

    public var body: some View {
        // WithPerceptionTracking 없이 바로 작성
        VStack { ... }
        .onAppear { store.send(.view(.onAppear)) }
    }
}
```

## Delegate 패턴 — 자식 → 부모 통신

자식 Feature는 직접 화면 전환하지 않고 delegate action으로 부모에게 위임:
```swift
// 자식
case .delegate:
    return .none  // 자식은 delegate를 직접 처리하지 않음

// 부모
case .splash(.delegate(.navigateToHome)):
    state.splash = nil
    state.home = HomeFeature.State()
    return .none
```

## Dependency 패턴

```swift
// Interface 정의 (Core/Dependency)
@DependencyClient
public struct APIClient: Sendable {
    public var fetchData: @Sendable () async throws -> [Model]
}

extension APIClient: TestDependencyKey {
    public static let testValue = Self()
}

// Reducer에서 사용
@Dependency(\.apiClient) var apiClient
```

## Effect 패턴

```swift
// ✅ .run으로 비동기 작업
case .view(.onAppear):
    return .run { send in
        let data = try await apiClient.fetchData()
        await send(.dataLoaded(data))
    }

// ✅ .send로 동기 액션 전달
case .view(.buttonTapped):
    return .send(.delegate(.didFinish))

// ❌ View에서 직접 비동기 작업 수행 금지
// Task { } 를 View에서 사용하지 않음
```

## Optional State + ifLet 네비게이션

```swift
// State
public var detail: DetailFeature.State?

// Reducer body
.ifLet(\.detail, action: \.detail) { DetailFeature() }

// View
if let store = store.scope(state: \.detail, action: \.detail) {
    DetailView(store: store)
}
```
