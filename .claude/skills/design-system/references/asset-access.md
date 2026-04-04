# Accessing DesignSystem Assets from Feature Modules

## ⚠️ ResourceSynthesizers 자동 생성 구조

이 프로젝트는 `Tuist/ResourceSynthesizers/`에 커스텀 템플릿이 설정되어 있습니다:
- `Colors.stencil` — Colors.xcassets의 컬러를 자동으로 extension 생성
- `images.stencil` — Assets.xcassets(Images)의 이미지를 자동으로 extension 생성

`tuist generate` 실행 시 `Derived/Sources/`에 type-safe accessor가 자동 생성됩니다.
**수동으로 DSColors.swift 같은 파일을 별도로 만들지 않습니다.**

## 에셋 추가 절차

### 컬러 추가
1. `Projects/DesignSystem/Resources/Colors.xcassets/`에 colorset 추가
2. `tuist generate` 실행
3. 자동 생성된 extension으로 바로 사용 가능

### 이미지 추가
1. `Projects/DesignSystem/Resources/Assets.xcassets/`에 imageset 추가
2. `tuist generate` 실행
3. 자동 생성된 extension으로 바로 사용 가능

**별도의 Assets 폴더를 새로 만들지 않습니다.** 기존 폴더에 추가하면 자동 반영됩니다.

## Image Access

```swift
import DesignSystem

// SwiftUI
Image(uiImage: DesignSystemAsset.Common.arrowLeft.image)
Image(uiImage: DesignSystemAsset.Feature.Splash.splashLogo.image)

// UIKit
let image = DesignSystemAsset.Common.close.image
```

## Color Access

```swift
import DesignSystem

// ResourceSynthesizers가 자동 생성한 accessor 사용
// 정확한 접근 방식은 Colors.stencil 템플릿에 따라 결정됨
// tuist generate 후 Derived/Sources/ 에서 생성된 코드 확인
```

## Font Access

```swift
import DesignSystem

// SwiftUI
Text("Hello")
    .font(.custom(DesignSystemFontFamily.Pretendard.bold.name, size: 16))

// UIKit
label.font = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
```

## Lottie Access

```swift
import DesignSystem
import Lottie

// DSLottieView 사용 (DesignSystem 모듈에 포함)
DSLottieView(name: "splash60") {
    // onComplete 콜백
}
```

## Important Notes

1. **Always import DesignSystem** in Feature modules that use assets
2. **Never duplicate assets** in Feature modules — always reference DesignSystem
3. **Run `tuist generate`** after adding new assets to regenerate accessors
4. **Colors.xcassets에 추가** → tuist generate → 자동으로 extension 생성
5. **Assets.xcassets에 추가** → tuist generate → 자동으로 extension 생성
6. **수동으로 Color/Image extension 파일을 만들지 않음** — ResourceSynthesizers가 관리
