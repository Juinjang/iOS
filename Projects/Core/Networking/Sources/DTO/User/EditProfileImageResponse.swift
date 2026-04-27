public struct EditProfileImageResponse: Decodable, Sendable {
    public let nickname: String
    public let email: String
    public let provider: String
    public let image: String
}
