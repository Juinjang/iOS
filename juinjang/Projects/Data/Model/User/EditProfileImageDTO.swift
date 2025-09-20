import Foundation

public struct EditProfileImageDTO: Codable {
    let nickname: String
    let email: String
    let provider: String
    let image: String
}
