import Foundation

public struct RefreshDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let email: String
}
