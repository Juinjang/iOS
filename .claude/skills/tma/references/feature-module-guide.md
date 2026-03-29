# Adding a New Feature Module (Step-by-Step)

## Prerequisites
- Tuist installed and configured
- Understanding of the module structure

## Step 1: Register the Module

Edit `Tuist/ProjectDescriptionHelpers/Module.swift`:

```swift
public enum Feature: String, CaseIterable {
    case home = "Home"
    case splash = "Splash"
    case onboarding = "Onboarding"
    case login = "Login"
    case myFeature = "MyFeature"  // <- Add here
}
```

## Step 2: Create Directory Structure

```
Projects/Feature/MyFeature/
├── Sources/
│   └── MyFeatureView.swift        (placeholder)
├── Testing/
│   └── MyFeatureMock.swift        (placeholder)
├── Tests/
│   └── MyFeatureTests.swift       (placeholder)
├── Example/
│   └── Sources/
│       └── MyFeatureExampleApp.swift
└── Project.swift
```

## Step 3: Create Project.swift

```swift
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    module: .myFeature,
    dependencies: [
        .core(.dependency),
        .core(.model),
        .core(.common)
    ],
    hasResources: false,
    includeExample: true
)
```

## Step 4: Create Minimum Source Files

### Sources/MyFeatureView.swift
```swift
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MyFeature {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case onAppear
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}

public struct MyFeatureView: View {
    let store: StoreOf<MyFeature>

    public init(store: StoreOf<MyFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            Text("MyFeature")
                .onAppear { store.send(.onAppear) }
        }
    }
}
```

### Testing/MyFeatureMock.swift
```swift
import Foundation

// Add mock data and test doubles here
public enum MyFeatureMock {
    // public static let sampleState = MyFeature.State()
}
```

### Tests/MyFeatureTests.swift
```swift
import Testing
import ComposableArchitecture
@testable import MyFeature

@MainActor
struct MyFeatureTests {
    @Test
    func testOnAppear() async {
        let store = TestStore(initialState: MyFeature.State()) {
            MyFeature()
        }
        await store.send(.onAppear)
    }
}
```

### Example/Sources/MyFeatureExampleApp.swift
```swift
import SwiftUI
import ComposableArchitecture
import MyFeature

@main
struct MyFeatureExampleApp: App {
    var body: some Scene {
        WindowGroup {
            MyFeatureView(
                store: Store(initialState: MyFeature.State()) {
                    MyFeature()
                }
            )
        }
    }
}
```

## Step 5: Wire Up in App

Add the feature dependency in `Projects/App/Project.swift`:
```swift
.feature(.myFeature)
```

## Step 6: Generate

```bash
tuist generate
```

## Step 7: Verify

- Build the main app target
- Build the Example app target independently
- Run the unit tests
