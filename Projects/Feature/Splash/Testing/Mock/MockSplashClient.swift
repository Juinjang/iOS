import Foundation
import Model
import Dependency

public struct MockSplashClient {
    public static let splashMock = AppVersionClient(
        latestVersion: { "1.0.0" },
        currentVersion: { "1.0.0" }
    )
    
    public static let updatePopupMock = AppVersionClient(
        latestVersion: { "2.0.0" },
        currentVersion: { "1.0.0" }
    )
}
