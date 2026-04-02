# 런타임 경고 및 에러

## 1. 중복 클래스 경고 (PerceptionCore, IssueReporting)

### 증상
```
objc: Class _TtCV14PerceptionCore20_PerceptionRegistrar... is implemented
in both SwiftNavigation.framework and Sharing.framework.
One of the two will be used. Which one is undefined.

objc: Class _TtC14IssueReporting15FailureObserver is implemented
in both XCTestDynamicOverlay.framework and CustomDump.framework.
```

### 원인
`IssueReporting`, `IssueReportingPackageSupport`, `PerceptionCore`가
static library인데 여러 dynamic framework에 각각 링크되어 중복 포함됨.

tuist generate 시에도 같은 경고 발생:
```
Target 'IssueReporting' has been linked from target 'CasePaths',
target 'Clocks', target 'CombineSchedulers', ...
it is a static product so may introduce unwanted side effects.
```

### 영향
- 앱 동작에는 영향 없음 (경고 수준)
- 바이너리 크기가 약간 증가할 수 있음

### 해결 방법
Package.swift에서 해당 패키지도 dynamic framework로 지정:
```swift
"IssueReporting": .framework,
"IssueReportingPackageSupport": .framework,
"PerceptionCore": .framework,
```

### 주의사항
- 이 설정을 추가하면 tuist generate 경고는 사라짐
- 하지만 매크로 충돌 에러가 추가로 발생할 수 있으므로 신중히 적용
- 현재는 경고를 무시하는 것이 안정적

---

## 2. MetalTools / CA Event 경고

### 증상
```
NSBundle .../MetalTools.framework/ principal class is nil
because all fallbacks have failed

Failed to send CA Event for app launch measurements
```

### 원인
시뮬레이터 환경에서 Metal 프레임워크 관련 경고.
실기기에서는 발생하지 않음.

### 영향
- 무시 가능, 시뮬레이터 한정 경고
- 앱 기능에 영향 없음

---

## 3. Xcode DerivedData 충돌

### 증상
- 빌드는 성공하지만 이전 버전이 실행됨
- 코드 변경이 반영되지 않음

### 원인
같은 프로젝트의 DerivedData가 여러 개 존재할 수 있음:
- 원본 디렉토리용 DerivedData
- git worktree용 DerivedData

### 해결
```bash
# 모든 Juinjang DerivedData 삭제
rm -rf ~/Library/Developer/Xcode/DerivedData/Juinjang-*

# 또는 특정 것만 삭제
ls ~/Library/Developer/Xcode/DerivedData/ | grep Juinjang
rm -rf ~/Library/Developer/Xcode/DerivedData/Juinjang-<hash>
```

### 전체 캐시 초기화 절차
```bash
# 1. Tuist 캐시 초기화
tuist clean

# 2. DerivedData 삭제
rm -rf ~/Library/Developer/Xcode/DerivedData/Juinjang-*

# 3. 의존성 재설치 + 프로젝트 재생성
tuist install
tuist generate
```
