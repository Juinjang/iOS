---
name: base-conventions
description: 프로젝트 전체 공통 규칙 — 모든 Agent와 Skill이 참조하는 단일 소스 오브 트루스
---

# Base Conventions Skill

## Overview
Juinjang iOS 프로젝트의 공통 규칙을 정의합니다.
모든 Agent와 Skill은 이 규칙을 우선적으로 따르며, 충돌 시 base-conventions가 우선합니다.

## When to Use
- 코드를 생성하기 전에 항상 참조
- Agent 간 패턴 충돌이 발생할 때
- 새 Agent/Skill을 추가할 때 기준 확인

## References
All reference files are located in `./references/` directory:

- `_index.md` - 빠른 참조 인덱스
- `swift-style.md` - Swift 버전, iOS 타겟, 네이밍 컨벤션
- `tca-patterns.md` - TCA 바인딩, Reducer 구조, Effect 패턴 통일 규칙
- `preview-rules.md` - Preview 위치, mock 의존성, 스킴 규칙

## 우선순위
1. base-conventions (이 스킬) — 최우선
2. 개별 Skill (tca, tma, preview 등) — 상세 가이드
3. 개별 Agent (swiftui-builder 등) — 실행 지침
