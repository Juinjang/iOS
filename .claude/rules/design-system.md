# DesignSystem Rules

## ResourceSynthesizers — 자동 생성
`tuist generate` 시 자동으로 type-safe extension 생성:
- `Colors.xcassets/` → `Color.xxx` extension
- `Images.xcassets/` → `Image.xxx` extension
- `Fonts/` → `DesignSystemFontFamily.xxx` extension

## 에셋 추가 절차
1. 해당 xcassets 폴더에 에셋 추가
2. `tuist generate` 실행
3. 자동 생성된 extension으로 사용

## 금지 사항
- 수동으로 Color/Image extension 파일 생성 금지 (DSColors.swift 등)
- 별도의 Assets 폴더 생성 금지 — 기존 Images.xcassets 사용
- Feature 모듈에 에셋 중복 금지 — DesignSystem만 참조

## Lottie
- `DSLottieView` 사용 (DesignSystem 모듈)
- Lottie 4.x native SwiftUI `LottieView` 기반
- Lottie 파일은 `Resources/Lotties/`에 배치

## 폴더 구조
```
DesignSystem/Resources/
├── Colors.xcassets     # 컬러
├── Images.xcassets     # 이미지
├── Fonts/              # 폰트
└── Lotties/            # Lottie JSON
```
