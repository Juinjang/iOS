# Xcode Preview 관련 이슈

## 1. Preview 무한 부팅 (Infinite Loading)

### 증상
- Preview가 "Preparing..." 또는 시뮬레이터 부팅 상태에서 무한 대기
- 빌드는 성공하고 시뮬레이터 실행도 되지만 Preview만 안 뜸
- 단순한 Text("Hello") View도 Preview 불가

### 원인 (복합적)

**A. Static Framework 제한 (근본 원인)**
Xcode Preview는 static framework/library를 지원하지 않음.
Tuist에서 `.staticFramework`로 설정된 모듈은 Preview가 코드를 동적으로 로드 불가.

참고 이슈:
- tuist/tuist#2609 — static framework에서 Preview 시 `ConfigurationError: noPreviewInfos`
- tuist/tuist#6222 — `.staticFramework` 사용 시 `#Preview` 매크로 컴파일 실패
- tuist/tuist Discussion #5318 — Preview 빌드에서 리소스 번들 타겟 누락

**B. TCA 매크로 빌드 부하**
`ComposableArchitectureMacros` 빌드에 모든 CPU 코어 95% 이상 사용.
TCA 1.x 이후 매크로 도입으로 빌드 시간 ~8배 증가 보고됨.
Preview가 매크로 바이너리를 찾지 못하면 무한 대기 상태.

**C. Xcode 26 Beta 자체 이슈**
- Preview 사용 시 시스템 크래시/리부팅 보고
- Metal Toolchain 미설치 시 Preview 빌드 실패

### 해결

**1단계: Feature/Core/DesignSystem 모듈을 dynamic framework로 변경**
```swift
// Project+Feature.swift, Project+Core.swift, Project+DesignSystem.swift
product: .framework,  // .staticFramework → .framework
```

**2단계: Legacy Preview Execution 활성화**
Xcode 메뉴: Editor → Canvas → Use Legacy Previews Execution 체크

**3단계: Metal Toolchain 설치**
```bash
xcodebuild -downloadComponent MetalToolchain
```

**4단계 (선택): Generation Time Configuration으로 개발/릴리즈 분리**
```swift
// Environment.swift
public static var isPreview: Bool {
    ProcessInfo.processInfo.environment["TUIST_PREVIEW"] == "1"
}

// Project+Feature.swift
product: Environment.isPreview ? .framework : .staticFramework,
```
```bash
# Preview 개발용
TUIST_PREVIEW=1 tuist generate

# 릴리즈 빌드용 (static으로 빌드 최적화)
tuist generate
```

---

## 2. SDKStatCache Not Found

### 증상
```
Compiling failed: stat cache file
'.../SDKStatCaches.noindex/iphonesimulator26.2-23C57-dc75598d...sdkstatcache'
not found
```

### 원인
Xcode 26.3 정식 버전에서도 발생하는 버그. Preview 빌드 시스템이 요구하는 SDK 해시와
실제 생성되는 SDK 캐시 파일의 해시가 불일치.
캐시를 삭제해도 같은 (다른) 해시로 재생성되므로 삭제만으로는 해결 안 됨.

### 해결
에러 메시지의 파일명으로 심볼릭 링크 생성:
```bash
# 1. 실제 존재하는 캐시 파일 확인
ls ~/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/

# 2. 에러에서 요구하는 파일명으로 심볼릭 링크 생성
ln -s ~/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.2-23C57-<실제해시>.sdkstatcache \
      ~/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex/iphonesimulator26.2-23C57-<요구해시>.sdkstatcache
```

### 주의사항
- Xcode 업데이트 시 해시가 바뀔 수 있으므로 재적용 필요
- Xcode 16.x에서는 발생하지 않음. 26.3 정식에서도 발생 확인됨

---

## 3. Preview "NoBuildableEntriesError"

### 증상
```
NoBuildableEntriesError: Active scheme does not build this file
Select a scheme that builds a target which contains the current file
```

### 원인
현재 선택된 Xcode 스킴이 Preview 대상 파일의 타겟을 빌드하지 않음.

### 해결
Preview 대상 파일에 맞는 스킴 선택:

| 파일 위치 | 선택할 스킴 |
|-----------|------------|
| Feature/Home/Example/ | HomeExample |
| Feature/Splash/Example/ | SplashExample |
| Feature/Login/Example/ | LoginExample |
| Feature/Home/Sources/ | Home 또는 HomeExample |
| App/Sources/ | juinjang-dev |

---

## 4. Preview에서 Lottie 로딩 느림/멈춤

### 증상
- Lottie 애니메이션 포함 View의 Preview가 극도로 느림
- splash60.json (15MB) 같은 대용량 Lottie 파일 파싱에 시간 소모

### 원인
Preview는 JIT 컴파일로 동작하는데, 15MB JSON 파일을 파싱하면서
Preview 부팅이 느려짐.

### 해결
`DSLottieView`에서 Preview 환경 감지하여 Lottie 로딩 건너뛰기:
```swift
public var body: some View {
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
        Color.clear
            .onAppear { onComplete?() }
    } else {
        LottieView(animation: .named(name, bundle: .module))
            .playing(loopMode: loopMode)
            .animationDidFinish { completed in
                if completed { onComplete?() }
            }
    }
}
```

`XCODE_RUNNING_FOR_PREVIEWS`는 Xcode가 Preview 실행 시 자동 설정하는 환경변수.

---

## 5. DerivedData 충돌로 Preview 오작동

### 증상
- 코드 변경이 Preview에 반영 안 됨
- 이전 빌드 결과가 계속 표시됨

### 원인
동일 프로젝트의 DerivedData가 여러 개 존재 (원본 + worktree 등)

### 해결
```bash
# 모든 Juinjang DerivedData + SDKStatCaches 삭제
rm -rf ~/Library/Developer/Xcode/DerivedData/Juinjang-*
rm -rf ~/Library/Developer/Xcode/DerivedData/SDKStatCaches.noindex

# Xcode 완전 종료 후 재시작
```
