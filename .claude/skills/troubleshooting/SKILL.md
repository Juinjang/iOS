---
name: troubleshooting
description: Tuist + TCA + SwiftUI 프로젝트 빌드/런타임 트러블슈팅 가이드
---

# Troubleshooting Skill

## Overview
Tuist 모듈화 프로젝트에서 빌드 실패, 검정화면, 매크로 충돌 등
반복 발생 가능한 이슈와 해결 방법을 정리한 스킬.

## When to Use
- 빌드가 실패할 때
- 앱 실행 시 검정화면이 나올 때
- Tuist generate가 실패할 때
- TCA 매크로 관련 에러가 발생할 때
- Xcode Preview가 동작하지 않을 때
- 런타임 경고/에러 로그가 발생할 때

## References
All reference files are located in `./references/` directory:

- `_index.md` - 이슈 빠른 참조 인덱스
- `infoplist-issues.md` - Info.plist 누락으로 인한 검정화면, LaunchScreen 관련
- `tuist-build-issues.md` - Tuist generate 실패, XCConfig, 매크로 충돌
- `runtime-warnings.md` - 런타임 중복 클래스 경고, 다크모드 이슈
- `preview-issues.md` - Xcode Preview 무한 부팅, static framework, SDKStatCache
