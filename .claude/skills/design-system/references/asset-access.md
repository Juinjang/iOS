# Accessing DesignSystem Assets from Feature Modules

## How Tuist Resource Accessors Work

When `hasResources: true` in the DesignSystem project config, Tuist generates:
- `Derived/Sources/TuistAssets+DesignSystem.swift` — image and color accessors
- `Derived/Sources/TuistFonts+DesignSystem.swift` — font accessors
- `Derived/Sources/TuistBundle+DesignSystem.swift` — bundle accessor

These are auto-generated on `tuist generate` and should NOT be edited manually.

## Image Access

```swift
import DesignSystem

// SwiftUI
Image(uiImage: DesignSystemAsset.Common.arrowLeft.image)
Image(uiImage: DesignSystemAsset.Feature.Splash.splashLogo.image)
Image(uiImage: DesignSystemAsset.Brand.logo.image)

// UIKit
let image = DesignSystemAsset.Common.close.image
imageView.image = DesignSystemAsset.Feature.Login.kakaoLogo.image
```

## Color Access

```swift
import DesignSystem

// SwiftUI
Color(DesignSystemAsset.Colors.main.color)
Color(DesignSystemAsset.Colors.gray600.color)
Color(DesignSystemAsset.Colors.splash.color)

// UIKit
let color = DesignSystemAsset.Colors.main.color
view.backgroundColor = DesignSystemAsset.Colors.bg.color
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

Lottie files are raw resources, accessed via bundle:

```swift
import DesignSystem
import Lottie

// Get Lottie animation from DesignSystem bundle
let bundle = DesignSystemResources.bundle
let animation = LottieAnimation.named("splash60", bundle: bundle)

// In SwiftUI with LottieView
LottieView(animation: .named("splash60", bundle: DesignSystemResources.bundle))
```

## Important Notes

1. **Always import DesignSystem** in Feature modules that use assets
2. **Never duplicate assets** in Feature modules — always reference DesignSystem
3. **Run `tuist generate`** after adding new assets to regenerate accessors
4. **Accessor naming** follows the xcassets group/file structure:
   - `Assets.xcassets/Common/arrow-left.imageset` → `DesignSystemAsset.Common.arrowLeft.image`
   - `Colors.xcassets/Gray/gray100.colorset` → `DesignSystemAsset.Colors.gray100.color`
5. **Kebab-case** in file names becomes **camelCase** in generated code
