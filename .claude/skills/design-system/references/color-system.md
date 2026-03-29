# Color System

## Brand Palette (from develop branch)

### Main (Brand Orange)
| Name | Hex | Usage |
|------|-----|-------|
| `main` | Primary brand | Buttons, highlights, primary actions |
| `main100` | Lighter variant | Subtle backgrounds |
| `main150` | Light variant | Hover/pressed states |
| `main200` | Medium variant | Secondary elements |
| `mainStroke` | - | Borders on brand elements |
| `mainGradient1` | - | Gradient start |
| `mainGradient2` | - | Gradient end |
| `mainShadow` | - | Shadow color for brand elements |

### Gray Scale
| Name | Usage |
|------|-------|
| `gray100` | Lightest - subtle dividers |
| `gray200` | Light backgrounds |
| `gray300` | Disabled text, placeholders |
| `gray350` | Secondary text (light) |
| `gray400` | Secondary text |
| `gray420` | Medium text |
| `gray430` | Body text (light) |
| `gray450` | Body text |
| `gray500` | Primary text (light) |
| `gray600` | Primary text / headings |

### Background
| Name | Usage |
|------|-------|
| `bg` | Primary background |
| `bg2` | Secondary/card background |
| `mainWhite` | Pure white elements |

### Stroke
| Name | Usage |
|------|-------|
| `stroke` | Primary borders |
| `stroke2` | Secondary/subtle borders |
| `stroke3` | Tertiary borders |

### Accent
| Name | Hex | Usage |
|------|-----|-------|
| `splash` | `#FF7927` | Splash screen background |
| `point` | - | Accent/highlight color |

## Usage in SwiftUI

```swift
// Via Tuist-generated accessor
Color(DesignSystemAsset.Colors.main.color)
Color(DesignSystemAsset.Colors.gray600.color)
Color(DesignSystemAsset.Colors.splash.color)

// For UIKit interop
UIColor(resource: .main)
```

## Dark Mode
Currently single appearance (no dark mode variants).
When adding dark mode support, add "dark" appearance in each colorset's Contents.json.
