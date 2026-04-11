# Architecture Rules

## 모듈 의존성 방향
```
App → Feature → Core/Dependency, Core/Model, Core/Common, DesignSystem
                Core/Networking → Core/Dependency, Core/Model, Core/Common
```
- Feature → Feature 의존 금지 (순환 의존)
- Feature → Core/Networking 의존 금지 (인터페이스만 알아야 함)

## Dependency 모듈 (인터페이스)
- `@DependencyClient` 인터페이스만 정의
- `TestDependencyKey` 등록
- `DependencyValues` extension 등록
- 실제 구현 없음

## Networking 모듈 (Live 구현체)
- `DependencyKey` conformance (`liveValue`)
- iTunes API, Alamofire 등 실제 네트워크 호출
- UIKit import 금지
- 디렉토리: `Base/` (인프라), `API/` (엔드포인트), `Clients/` (Live 구현), `DTO/` (모델)

## 모듈 생성
- `tuist scaffold Feature --name {Name}` 우선 사용
- Agent는 scaffold로 커버 안 되는 커스텀 로직에만

## Delegate 패턴 — 자식 → 부모 통신
```swift
// 자식: delegate 발행만
case .delegate: return .none

// 부모: delegate 받아서 화면 전환
case .splash(.delegate(.navigateTo(.home))):
    state.splash = nil
    state.home = HomeFeature.State()
    return .none
```

## Optional State + ifLet 네비게이션
- 루트 화면 교체: Optional State + `.ifLet`
- push/pop 네비게이션: `StackState` (향후)
