# Base Conventions Quick Reference

## 프로젝트 기본 정보

| 항목 | 값 |
|------|-----|
| iOS 최소 버전 | 17.0 |
| Swift 버전 | 6.0 |
| TCA 버전 | 1.24.1+ |
| Tuist 버전 | 4.43.2+ |
| 아키텍처 | TCA + TMA (Tuist Modular Architecture) |
| Concurrency | Swift Strict Concurrency (complete) |

## 핵심 규칙 요약

| 주제 | 규칙 | 참조 |
|------|------|------|
| 바인딩 | `@Bindable` 사용 (NOT `@Perception.Bindable`) | tca-patterns.md |
| Perception 추적 | `WithPerceptionTracking` 불필요 | tca-patterns.md |
| Reducer 매크로 | `@Reducer`, `@ObservableState` 사용 | tca-patterns.md |
| Preview 위치 | Example 타겟에만 작성, Sources에 #Preview 금지 | preview-rules.md |
| Preview 스킴 | `{Feature}Example` 스킴 선택 후 실행 | preview-rules.md |
| 모듈 의존성 | App → Feature → Core/DesignSystem → 외부 의존성 없음 | swift-style.md |
| 네이밍 | Feature: `{Name}Feature`, View: `{Name}View`, Tests: `{Name}FeatureTests` | swift-style.md |
| 모듈 생성 | `tuist scaffold` 템플릿 우선 사용, Agent는 커스텀 로직에만 | swift-style.md |
