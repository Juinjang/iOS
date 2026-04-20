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

## 에셋 접근 방식
- 컬러: `Color.splash`, `Color.main` (자동 생성 extension)
- 이미지: `Image.logo`, `Image.arrowLeft` (자동 생성 extension)
- 폰트: `DesignSystemFontFamily.Pretendard.bold.swiftUIFont(size:)`
- `Image("name", bundle: .module)` 직접 사용 금지 → `Image.name` 사용

## 금지 사항
- 수동으로 Color/Image extension 파일 생성 금지 (DSColors.swift 등)
- `Image("name", bundle: .module)` 직접 사용 금지 — Tuist 자동 생성 accessor 사용
- 이미지에 색상 적용 시 `.renderingMode(.template)` 필수 — 없으면 `foregroundStyle` 무시됨
- `Font.custom("Pretendard-Bold", size:)` 직접 사용 금지 — `DSFontStyle` 또는 `DesignSystemFontFamily` 사용
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

DesignSystem/Sources/
├── Enum/               # 열거형 데이터
└── Components/         # 공통 컴포넌트
```
