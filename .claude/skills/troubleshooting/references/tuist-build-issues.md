# Tuist 빌드 관련 이슈

## 1. Multiple commands produce (TCA 매크로 충돌)

### 증상
```
error: Multiple commands produce '.../DependenciesMacrosPlugin'
error: Multiple commands produce '.../ComposableArchitectureMacros'
error: Multiple commands produce '.../CasePathsMacros'
error: Multiple commands produce '.../PerceptionMacros'
```

### 원인
Tuist 4.x가 TCA 매크로 패키지를 처리할 때:
1. 라이브러리 타겟에 "Copy Swift Macro executable" script phase 생성
2. 별도의 매크로 플러그인 타겟도 같은 실행파일을 생성
→ 같은 출력 파일을 두 곳에서 생성하여 충돌

### 해결
`xcodebuild` CLI에서 `-sdk iphonesimulator` 옵션을 제거하고
`-destination`만 사용:

```bash
# 실패:
xcodebuild -workspace Juinjang.xcworkspace -scheme juinjang-dev \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build

# 성공:
xcodebuild -workspace Juinjang.xcworkspace -scheme juinjang-dev \
  -destination 'platform=iOS Simulator,id=<DEVICE_UUID>' build
```

### 참고
- Tuist GitHub 이슈: tuist/tuist#7164, #6320
- Xcode GUI에서는 발생하지 않을 수 있음
- Tuist 버전 업그레이드로 해결될 수 있음 (4.43.2 기준 미해결)

---

## 2. tuist generate 실패 (XCConfig 파일 누락)

### 증상
```
Configuration file not found at path .../Projects/XCConfig/Debug.xcconfig
Configuration file not found at path .../Projects/XCConfig/Release.xcconfig
Fatal linting issues found
```

### 원인
`AppTargetType.swift`에서 xcconfig 경로를 참조하지만
실제 파일이 존재하지 않음. `.gitignore`에 `*.xcconfig`가 있어서
git clone 시 파일이 포함되지 않음.

### 해결
빈 xcconfig 파일 수동 생성:
```bash
mkdir -p Projects/XCConfig
echo "// Debug configuration" > Projects/XCConfig/Debug.xcconfig
echo "// Release configuration" > Projects/XCConfig/Release.xcconfig
```

### 주의사항
- `.gitignore`에 `*.xcconfig`가 포함되어 있으므로 git push 안 됨
- 새로운 개발자 온보딩 시 xcconfig 생성 절차 안내 필요
- 환경별 민감 정보(API key 등)를 xcconfig에 넣는 경우 gitignore 유지

---

## 3. AppIcon 빌드 에러 (대소문자 불일치)

### 증상
```
error: None of the input catalogs contained a matching stickers icon set,
app icon set, or icon stack named "AppIcon-dev".
```

### 원인
`AppTargetType.swift`에서 `appIconName`이 `AppIcon-dev`(소문자)인데
실제 xcassets 폴더명이 `AppIcon-Dev`(대문자 D).
macOS는 대소문자 구분 없지만 Xcode 빌드 시스템은 구분함.

### 해결
```swift
// AppTargetType.swift
case .dev:
    return "AppIcon-Dev"  // xcassets 폴더명과 정확히 일치
```

### 예방
- xcassets 폴더명과 코드 참조를 항상 동일하게 유지
- 새 아이콘셋 추가 시 AppTargetType.swift 동기화 확인

---

## 4. Preview "NoBuildableEntriesError"

### 증상
```
NoBuildableEntriesError: Active scheme does not build this file
Select a scheme that builds a target which contains the current file
```

### 원인
현재 선택된 Xcode 스킴(예: `juinjang-dev`)이
Preview를 실행하려는 파일의 타겟(예: `HomeExample`)을 빌드하지 않음.

### 해결
Preview 대상 파일에 맞는 스킴 선택:

| 파일 위치 | 선택할 스킴 |
|-----------|------------|
| Feature/Home/Example/ | HomeExample |
| Feature/Splash/Example/ | SplashExample |
| Feature/Login/Example/ | LoginExample |
| App/Sources/ | juinjang-dev |

---

## 5. productName 한글 경고

### 증상
```
Invalid product name '주인장'. This string must contain only
alphanumeric (A-Z,a-z,0-9), period (.), hyphen (-), and underscore (_)
```

### 원인
`AppTargetType.displayName`이 한글("주인장")인데
`makeAppTarget`에서 `productName`으로 사용됨.
Tuist가 유효하지 않은 product name으로 경고.

### 해결 (필요 시)
```swift
// Target+Extensions.swift
productName: appType.targetName,  // "주인장" 대신 "juinjang" 사용
```
`CFBundleDisplayName`으로 한글 이름을 별도 설정하면
앱 아이콘 아래 표시 이름은 한글로 유지됨.
