# Juinjang iOS

부동산 임장 노트 앱 — SwiftUI + TCA + Tuist 모듈화 프로젝트

## 기술 스택

| 항목 | 버전 |
|------|------|
| iOS 최소 타겟 | 17.0 |
| Swift | 6.0 (Strict Concurrency: complete) |
| TCA | 1.24.1+ |
| Tuist | 4.43.2+ |
| Lottie | 4.x (native SwiftUI LottieView) |
| Alamofire | 5.x |

## 모듈 구조

```
App (juinjang / juinjang-dev)
 ├── Feature/Splash
 ├── Feature/Onboarding
 ├── Feature/Login
 ├── Feature/Home
 ├── Core/Networking    (Live 구현체, Alamofire)
 └── DesignSystem       (Colors, Images, Fonts, Lottie, Components)

Core/Dependency          (Client 인터페이스, @DependencyClient)
Core/Model               (Domain 모델, DTO)
Core/Common              (Extension, AppInfo 상수)
```

### 의존성 방향
```
App → Feature → Core/Dependency, Core/Model, DesignSystem
                Core/Networking → Core/Dependency, Core/Model, Core/Common
                Feature → Feature (금지)
```

## 빌드 명령어

```bash
# 의존성 설치
tuist install

# 프로젝트 생성
tuist generate

# 빌드 (CLI)
xcodebuild -workspace Juinjang.xcworkspace -scheme juinjang-dev \
  -destination 'platform=iOS Simulator,id=<DEVICE_UUID>' build

# 새 Feature 모듈 생성
tuist scaffold Feature --name {Name}

# 새 Core 모듈 생성
tuist scaffold Core --name {Name}
```

## 핵심 규칙

- `@Bindable` 사용 (NOT `@Perception.Bindable`)
- `WithPerceptionTracking` 불필요 (iOS 17+)
- Feature에서 `UIKit` import 금지
- Preview는 Example 타겟에서만 (`{Feature}Example` 스킴)
- Sources에 `#Preview` 작성 금지
- 에셋은 `Colors.xcassets`, `Images.xcassets`에 추가 → `tuist generate`로 자동 extension 생성
- 모듈 생성은 `tuist scaffold` 우선

## Agent 구성 (4개)

| Agent | 모델 | 역할 |
|-------|------|------|
| `code-agent` | Sonnet | 코드 작성 전반 |
| `code-review` | Sonnet | 코드 리뷰 |
| `logic-agent` | Opus | 복잡한 설계/분석 |
| `bug-agent` | Opus | 버그 진단 + 수정 |

## Skills (5개)

| Skill | 내용 |
|-------|------|
| `tca` | TCA 패턴 레퍼런스 |
| `tma` | Tuist 모듈 구조 |
| `swiftui-expert-skill` | SwiftUI 레퍼런스 |
| `swift-concurrency` | Swift 6 동시성 |
| `swift-testing-expert` | Swift Testing 레퍼런스 |

## Rules (.claude/rules/)

| Rule | 내용 |
|------|------|
| `code-conventions.md` | 코드 컨벤션, 네이밍 규칙 |
| `architecture.md` | 모듈 구조, 의존성 방향 |
| `preview-rules.md` | Preview 위치, Example 타겟 |
| `design-system.md` | 에셋 관리, ResourceSynthesizers |
| `troubleshooting.md` | 빌드/런타임 트러블슈팅 |
