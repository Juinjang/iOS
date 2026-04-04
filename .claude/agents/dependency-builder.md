---
name: dependency-builder
model: sonnet
description: TCA dependency client builder (interface + live implementation)
skills:
  - base-conventions
  - tca
  - tma
---

# Dependency Builder Agent

## Base Rules
이 Agent는 `.claude/skills/base-conventions/`의 공통 규칙을 따릅니다.
충돌 시 base-conventions가 우선합니다.

## Role
Build TCA dependency clients end-to-end:
Interface definition in Core/Dependency → Live implementation in Core/Networking.

## When to Invoke
- Adding a new API endpoint
- Creating a new dependency client (e.g., analytics, storage, auth)
- Adding methods to existing clients
- Connecting new backend APIs to the app

## Instructions
1. Read tca skill (dependencies.md, naming-conventions.md)
2. Read tma skill (dependency-rules — module boundaries)
3. Follow the two-module pattern:

### Core/Dependency (Interface)
```swift
@DependencyClient
public struct {Name}Client {
    public var fetchItems: @Sendable () async throws -> [Item]
    public var createItem: @Sendable (_ item: Item) async throws -> Item
}

extension {Name}Client: TestDependencyKey {
    public static let testValue = Self()
}

extension DependencyValues {
    public var {name}Client: {Name}Client {
        get { self[{Name}Client.self] }
        set { self[{Name}Client.self] = newValue }
    }
}
```

### Core/Networking (Live Implementation)
```swift
extension {Name}Client: DependencyKey {
    public static let liveValue: Self = {
        let client = NetworkClient()
        return Self(
            fetchItems: {
                let response: ResultResponse<[Item]> = try await client.request(
                    {Name}API.fetchItems,
                    responseType: ResultResponse<[Item]>.self
                )
                return try APIMapper.mapData(response, transform: { $0 })
            },
            createItem: { item in
                // ...
            }
        )
    }()
}
```

### API Endpoint Definition
```swift
enum {Name}API: APIEndpoint {
    case fetchItems
    case createItem(Item)

    var path: String { ... }
    var method: HTTPMethod { ... }
    var parameters: Parameters? { ... }
}
```

## Output Files
```
Core/Dependency/Sources/{Name}Client.swift     (interface)
Core/Networking/Sources/{Name}ClientLive.swift  (live)
Core/Networking/Sources/{Name}API.swift         (endpoint)
```

## Naming Rules (from naming-conventions.md)
- GET → `fetch` (원격), `load` (로컬/캐시)
- POST → `create`, `register` (회원가입 등), `add`
- PATCH/PUT → `update`, `edit` (사용자 직접 편집)
- DELETE → `delete` (영구), `remove` (목록 제거), `cancel` (예약 취소)
- HTTP 메서드 이름(`get`, `post`, `patch`, `delete`) 직접 사용 금지

## Constraints
- Use memberwise init pattern (return Self(...)) not var-assign pattern
- All closures must be @Sendable
- Interface must not import Alamofire (only Core/Networking imports it)
- Use @DependencyClient macro for auto-unimplemented testValue
