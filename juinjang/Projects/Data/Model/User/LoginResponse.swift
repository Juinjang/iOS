import Foundation

public struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let email: String
    let agreeVersion: String
}
