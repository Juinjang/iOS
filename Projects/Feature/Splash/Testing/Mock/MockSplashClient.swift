import Foundation
import Model
import Dependency

public struct MockSplashClient {
    public static let splashMock: AppVersionClient = {
        var client = AppVersionClient.testValue
        client.latestVersion = { "1.0.0" }
        client.currentVersion = { "1.0.0" }
        return client
    }()

    public static let updatePopupMock: AppVersionClient = {
        var client = AppVersionClient.testValue
        client.latestVersion = { "2.0.0" }
        client.currentVersion = { "1.0.0" }
        return client
    }()
}
