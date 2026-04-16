import Lottie
import SwiftUI

// MARK: - DSLottieView
/// Reusable Lottie animation view using Lottie's native SwiftUI API (4.x+)
/// Supports iOS 17.0+

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
                if completed {
                    onComplete?()
                }
            }
    }
}
