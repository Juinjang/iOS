# Asset Organization Rules

## Images (Assets.xcassets)

### Directory Structure
```
Assets.xcassets/
├── Common/                    -> Shared across multiple features
│   ├── arrow-left.imageset
│   ├── arrow-right.imageset
│   ├── close.imageset
│   ├── check.imageset
│   ├── search.imageset
│   └── ...
├── Feature/                   -> Feature-specific images
│   ├── Splash/
│   │   └── (splash-specific images if any)
│   ├── Login/
│   │   ├── apple-logo.imageset
│   │   ├── kakao-logo.imageset
│   │   └── juinjang-logo.imageset
│   ├── Home/
│   │   └── ...
│   └── Onboarding/
│       └── ...
└── Brand/                     -> App-wide branding
    ├── logo.imageset
    └── juinjang-logo-graphic.imageset
```

### Naming Conventions

| Rule | Example | Avoid |
|------|---------|-------|
| lowercase kebab-case | `arrow-left` | `arrowLeft`, `Arrow_Left` |
| descriptive purpose | `bookmark-on`, `bookmark-off` | `icon1`, `img2` |
| size suffix when needed | `pencil-20`, `pencil-24` | `pencilSmall` |
| state suffix | `check-on`, `check-off` | `check1`, `check2` |
| no feature prefix in Common | `close` | `home-close` |
| feature prefix only outside Feature group | - | - |

### When to Put in Common vs Feature
- **Common**: Used by 2+ features (arrows, close, check, hearts, stars)
- **Feature/{Name}**: Used by only that feature
- **Brand**: Logo variants, marketing images

### Image Requirements
- Provide @1x, @2x, @3x or single PDF/SVG vector
- Prefer PDF vector for icons (scales cleanly)
- PNG for complex illustrations/photos
- Contents.json must specify `"rendering-intent": "template"` for tintable icons

## Colors (Colors.xcassets)

### Directory Structure
```
Colors.xcassets/
├── Gray/
│   ├── gray100.colorset      -> Lightest
│   ├── gray200.colorset
│   ├── gray300.colorset
│   ├── gray350.colorset
│   ├── gray400.colorset
│   ├── gray420.colorset
│   ├── gray430.colorset
│   ├── gray450.colorset
│   ├── gray500.colorset
│   └── gray600.colorset      -> Darkest
├── Main/
│   ├── main.colorset         -> Primary brand color
│   ├── main100.colorset
│   ├── main150.colorset
│   ├── main200.colorset
│   ├── mainGradient1.colorset
│   ├── mainGradient2.colorset
│   └── mainStroke.colorset
├── Background/
│   ├── bg.colorset
│   ├── bg2.colorset
│   └── mainWhite.colorset
├── Stroke/
│   ├── stroke.colorset
│   ├── stroke2.colorset
│   └── stroke3.colorset
└── Accent/
    ├── point.colorset
    └── splash.colorset        -> #FF7927 (orange)
```

### Color Naming Conventions
- Gray scale: `gray{number}` (100-600, higher = darker)
- Brand colors: `main`, `main{number}` for variants
- Functional: descriptive name (`bg`, `stroke`, `point`, `splash`)
- No hex values in names

## Lottie Animations (Lotties/)

### Directory Structure
```
Lotties/
├── splash60.json              -> Splash screen animation
└── onboarding/                -> Grouped by feature
    ├── checklist1.json
    ├── checklist2.json
    └── ...
```

### Naming Conventions
- lowercase with descriptive name
- Feature prefix for grouped files: `{feature}/{name}.json`
- Version/variant suffix if needed: `splash60.json`

## Fonts (Fonts/)

Already configured. Pretendard family with 9 weights (TTF).
Accessed via Tuist-generated `DesignSystemFontFamily.Pretendard.{weight}`.
