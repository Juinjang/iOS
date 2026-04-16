# Troubleshooting

## 빌드 실패

| 증상 | 원인 | 해결 |
|------|------|------|
| 검정화면 | infoPlist에 UILaunchStoryboardName 누락 | `.extendingDefault(with:)` 사용 |
| 다크모드 Safe Area 검정 | UIUserInterfaceStyle 미설정 | infoPlist에 "Light" 추가 |
| tuist generate 실패 | XCConfig 파일 누락 | 빈 xcconfig 수동 생성 |
| Multiple commands produce (매크로) | xcodebuild -sdk 옵션 | -sdk 제거, -destination만 사용 |
| AppIcon not found | 대소문자 불일치 | xcassets 폴더명과 정확히 일치 |

## Preview 이슈

| 증상 | 원인 | 해결 |
|------|------|------|
| 무한 부팅 | static framework | dynamic framework로 변경 |
| noPreviewInfos | Sources에 #Preview | Example 타겟에서만 작성 |
| sdkstatcache not found | SDK 해시 불일치 (Xcode 26) | 심볼릭 링크 생성 |
| NoBuildableEntries | 스킴 불일치 | {Feature}Example 스킴 선택 |

## 런타임 경고

| 증상 | 원인 | 영향 |
|------|------|------|
| PerceptionCore/IssueReporting 중복 | static library 다중 링크 | 없음 (무시) |
| dyld Sharing symbol missing | TCA Sharing과 Apple Sharing 이름 충돌 | 없음 (무시) |
| MetalTools principal class nil | 시뮬레이터 Metal 미지원 | 없음 |

## 전체 캐시 초기화
```bash
tuist clean
rm -rf ~/Library/Developer/Xcode/DerivedData/Juinjang-*
tuist install
tuist generate
```
