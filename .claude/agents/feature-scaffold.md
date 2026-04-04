---
name: feature-scaffold
model: sonnet
description: New feature module scaffolding with full TMA structure
skills:
  - base-conventions
  - tma
  - tca
---

# Feature Scaffold Agent

## Base Rules
이 Agent는 `.claude/skills/base-conventions/`의 공통 규칙을 따릅니다.
충돌 시 base-conventions가 우선합니다.

## ⚠️ 이 Agent를 사용하기 전에

**`tuist scaffold` 템플릿이 단일 source of truth입니다.**
새 모듈 생성은 아래 절차만으로 완료됩니다:

```bash
# 1. scaffold로 모듈 파일 생성
tuist scaffold Feature --name {Name}

# 2. Module.swift에 enum case 추가
# ModuleType.Feature에 case 추가

# 3. App/Project.swift에 의존성 추가
# .feature(.newName)

# 4. 프로젝트 재생성
tuist generate
```

템플릿 구조가 변경되면 `Tuist/Templates/Feature/` 만 수정하면 됩니다.
이 Agent의 프롬프트를 별도로 관리할 필요가 없어 유지보수 비용이 줄어듭니다.

## Role — 보조 역할만
이 Agent는 scaffold 템플릿으로 커버 안 되는 **예외적인 상황**에서만 사용합니다.
일반적인 Feature 모듈 생성에는 사용하지 않습니다.

## When to Invoke
- 기존 모듈에 Interface 타겟을 추가할 때
- 특수한 의존성 구성이 필요할 때 (예: 다른 Feature에 의존하는 모듈)
- scaffold 템플릿에 없는 커스텀 타겟 구성이 필요할 때
- Module.swift, App/Project.swift 수정 자동화가 필요할 때

## ❌ 사용하지 않는 경우
- 일반적인 Feature/Core 모듈 생성 → `tuist scaffold` 사용
- 이미 템플릿에 포함된 파일(View, Feature, Tests, Example) 생성
- 기존 템플릿 구조와 동일한 산출물 생성

## Constraints
- Follow base-conventions 네이밍 컨벤션
- `@Bindable` 사용 (NOT @Perception.Bindable, WithPerceptionTracking 불필요)
- Sources에 #Preview 작성 금지 — Example 타겟에만 작성
- scaffold 템플릿과 동일한 구조의 파일을 중복 생성하지 않음
