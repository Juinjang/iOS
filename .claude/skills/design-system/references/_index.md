# DesignSystem Quick Reference

## Module Info
- Path: `Projects/DesignSystem/`
- Product: staticFramework
- Dependencies: `Core/Common`
- All Feature modules depend on DesignSystem (auto-injected by Project+Feature.swift)

## Directory Structure
```
DesignSystem/
├── Sources/               -> Reusable SwiftUI components, extensions
├── Resources/
│   ├── Assets.xcassets/   -> Images
│   │   ├── Common/        -> Shared icons (arrows, close, check, etc.)
│   │   ├── Feature/       -> Feature-grouped images
│   │   │   ├── Splash/
│   │   │   ├── Login/
│   │   │   ├── Home/
│   │   │   └── Onboarding/
│   │   └── Brand/         -> Logos, app icons
│   ├── Colors.xcassets/   -> Color assets
│   │   ├── Gray/          -> gray100~gray600
│   │   ├── Main/          -> main, mainGradient, mainStroke, etc.
│   │   ├── Background/    -> bg, bg2, mainWhite
│   │   ├── Stroke/        -> stroke, stroke2, stroke3
│   │   └── Accent/        -> point, splash
│   ├── Lotties/           -> Lottie JSON animation files
│   │   ├── splash60.json
│   │   └── onboarding/
│   └── Fonts/             -> Pretendard font files (existing)
└── Project.swift
```

## Tuist Auto-Generated Accessors
When `hasResources: true`, Tuist generates:
- `DesignSystemAsset.{group}.{name}` for images
- `DesignSystemAsset.Colors.{name}` for colors (via Colors.xcassets)
- `DesignSystemFontFamily.Pretendard.{weight}` for fonts
