# Adding Tests to Core Modules

## Current State
Core modules (Dependency, Networking, Model, Common) have NO test targets.
`Project+Core.swift` only generates a single Source target.

## Step 1: Update Project+Core.swift

Add Testing and Tests targets to the core helper:

```swift
public extension Project {

    static func core(
        module: ModuleType.Core,
        dependencies: [TargetDependency] = [],
        hasResources: Bool = false,
        includeTests: Bool = false  // opt-in per module
    ) -> Project {

        let name = module.rawValue
        var targets: [Target] = [
            // Main target (existing)
            .target(
                name: name,
                destinations: .iOS,
                product: .staticFramework,
                bundleId: "com.juinjang.core.\(name.lowercased())",
                deploymentTargets: .iOS("17.0"),
                sources: ["Sources/**"],
                resources: hasResources ? ["Resources/**"] : nil,
                dependencies: dependencies,
                settings: .shared
            )
        ]

        var schemes: [Scheme] = [
            .scheme(
                name: name,
                buildAction: .buildAction(targets: [
                    TargetReference(stringLiteral: name)
                ])
            )
        ]

        if includeTests {
            // Testing target (mocks/stubs)
            targets.append(
                .target(
                    name: "\(name)Testing",
                    destinations: .iOS,
                    product: .staticFramework,
                    bundleId: "com.juinjang.core.\(name.lowercased()).testing",
                    deploymentTargets: .iOS("17.0"),
                    sources: ["Testing/**"],
                    dependencies: [.target(name: name)],
                    settings: .shared
                )
            )

            // Tests target
            targets.append(
                .target(
                    name: "\(name)Tests",
                    destinations: .iOS,
                    product: .unitTests,
                    bundleId: "com.juinjang.core.\(name.lowercased()).tests",
                    deploymentTargets: .iOS("17.0"),
                    sources: ["Tests/**"],
                    dependencies: [
                        .target(name: name),
                        .target(name: "\(name)Testing")
                    ],
                    settings: .shared
                )
            )

            // Update scheme to include tests
            schemes = [
                .scheme(
                    name: name,
                    buildAction: .buildAction(targets: [
                        TargetReference(stringLiteral: name)
                    ]),
                    testAction: TestAction.targets(
                        [TestableTarget(stringLiteral: "\(name)Tests")]
                    )
                )
            ]
        }

        return Project(
            name: name,
            settings: .shared,
            targets: targets,
            schemes: schemes
        )
    }
}
```

## Step 2: Enable Tests Per Module

In each Core module's `Project.swift`:

```swift
// Core/Networking/Project.swift
let project = Project.core(
    module: .networking,
    dependencies: [
        .core(.dependency),
        .core(.common),
        .core(.model),
        .external(.alamofire)
    ],
    includeTests: true  // <- enable tests
)
```

## Step 3: Create Test Directories

```bash
mkdir -p Projects/Core/Networking/Tests
mkdir -p Projects/Core/Networking/Testing
```

## What to Test in Each Core Module

### Core/Networking
- APIMapper response mapping (success/failure)
- NetworkClient request construction
- Error handling and mapping
- Response decoding

```swift
import Testing
@testable import Networking

@MainActor
struct APIMapperTests {
    @Test
    func mapDataExtractsResult() throws {
        let response = ResultResponse(
            result: "SUCCESS",
            data: [Post.mock]
        )
        let posts = try APIMapper.mapData(response, transform: { $0 })
        #expect(posts.count == 1)
    }

    @Test
    func mapDataThrowsOnFailure() {
        let response = ResultResponse<[Post]>(
            result: "FAIL",
            data: nil
        )
        #expect(throws: APIError.self) {
            try APIMapper.mapData(response, transform: { $0 })
        }
    }
}
```

### Core/Model
- Model encoding/decoding (Codable)
- Computed properties
- Equatable conformance

```swift
import Testing
@testable import Model

struct PostModelTests {
    @Test
    func decodingFromJSON() throws {
        let json = """
        {"id":"1","title":"Test","content":"Body","authorId":"u1","createdAt":"2024-01-01T00:00:00Z"}
        """.data(using: .utf8)!

        let post = try JSONDecoder().decode(Post.self, from: json)
        #expect(post.id == "1")
        #expect(post.title == "Test")
    }
}
```

### Core/Common
- Extension methods
- Utility functions
- Date/String formatters

### Core/Dependency
- Generally NOT tested directly (it's just interfaces)
- Test that `testValue` triggers `unimplemented` (automatic with @DependencyClient)
