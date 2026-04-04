# DesignSystem Component Guide

## Component Location

```
DesignSystem/
└── Sources/
    ├── Components/          -> Reusable SwiftUI views
    │   ├── Buttons/
    │   ├── Cards/
    │   ├── Alerts/
    │   └── Loading/
    ├── Extensions/          -> Color, Font, Image extensions
    │   ├── Color+DS.swift
    │   ├── Font+DS.swift
    │   └── Image+DS.swift
    └── Modifiers/           -> Custom ViewModifiers
```

## Component Conventions

### Naming
- Prefix with `DS` to avoid conflicts: `DSButton`, `DSCard`, `DSAlert`
- Or use a namespace enum: `DesignSystem.PrimaryButton`

### Structure
```swift
import SwiftUI

public struct DSPrimaryButton: View {
    let title: String
    let action: () -> Void

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom(DesignSystemFontFamily.Pretendard.bold.name, size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(DesignSystemAsset.Colors.main.color))
                .cornerRadius(12)
        }
    }
}
```

### Rules
1. All components must be `public`
2. All inits must be `public` and explicit
3. Use DesignSystem assets directly (colors, fonts, images)
4. No dependency on Feature modules or TCA
5. Components are pure UI — no business logic
6. Provide previews for each component

### Lottie View Component

Use Lottie 4.x native SwiftUI API (`LottieView`). iOS 17+ compatible.
Do NOT use `UIViewRepresentable` + `LottieAnimationView` — deprecated in Lottie 4.x.

```swift
import SwiftUI
import Lottie

public struct DSLottieView: View {
    private let name: String
    private let loopMode: LottieLoopMode
    private let onComplete: (() -> Void)?

    public init(
        name: String,
        loopMode: LottieLoopMode = .playOnce,
        onComplete: (() -> Void)? = nil
    ) {
        self.name = name
        self.loopMode = loopMode
        self.onComplete = onComplete
    }

    public var body: some View {
        LottieView(animation: .named(name, bundle: .module))
            .playing(loopMode: loopMode)
            .animationDidFinish { completed in
                if completed { onComplete?() }
            }
    }
}
```

Usage in Feature module:
```swift
import DesignSystem

DSLottieView(name: "splash60") {
    store.send(.animationCompleted)
}
```
