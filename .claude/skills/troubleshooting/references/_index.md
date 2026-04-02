# Troubleshooting Quick Reference

## 증상별 빠른 진단

| 증상 | 원인 | 참조 |
|------|------|------|
| 앱 실행 시 검정화면 | infoPlist에 UILaunchStoryboardName 누락 | infoplist-issues.md |
| 다크모드에서 Safe Area 검정 | UIUserInterfaceStyle: Light 미설정 | infoplist-issues.md |
| tuist generate 실패 (Fatal linting) | XCConfig 파일 누락 | tuist-build-issues.md |
| Multiple commands produce (매크로) | xcodebuild -sdk 옵션 충돌 | tuist-build-issues.md |
| AppIcon not found 빌드 에러 | AppIcon 대소문자 불일치 | tuist-build-issues.md |
| Preview "NoBuildableEntries" | 스킴 불일치 | tuist-build-issues.md |
| 런타임 중복 클래스 경고 | static library 다중 링크 | runtime-warnings.md |
