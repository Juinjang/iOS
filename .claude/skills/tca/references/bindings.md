# TCA Bindings

## @BindableState (Modern Approach)

With `@ObservableState`, use `@Bindable` in views:

```swift
@Reducer
struct FormFeature {
    @ObservableState
    struct State: Equatable {
        var username: String = ""
        var email: String = ""
        var isAgreed: Bool = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case submitTapped
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.username):
                // React to specific field change
                state.username = state.username.lowercased()
                return .none
            case .binding:
                return .none
            case .submitTapped:
                return .none
            }
        }
    }
}
```

## View Usage

```swift
struct FormView: View {
    @Bindable public var store: StoreOf<FormFeature>

    var body: some View {
        Form {
            TextField("Username", text: $store.username)
            TextField("Email", text: $store.email)
            Toggle("Agree to terms", isOn: $store.isAgreed)
            Button("Submit") { store.send(.submitTapped) }
        }
    }
}
```

## Key Rules
1. Action must conform to `BindableAction`
2. Include `case binding(BindingAction<State>)` in Action
3. Add `BindingReducer()` in body before `Reduce`
4. Use `$store.propertyName` for two-way bindings in views
5. React to specific field changes via `case .binding(\.fieldName)`
