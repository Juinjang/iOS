import Model

public struct ProfileResponse: Decodable, Sendable {
    public let nickname: String
    public let introduction: String?
    public let email: String
    public let image: String?
    public let provider: String

    public func toDomain() -> UserProfile {
        UserProfile(
            nickname: nickname,
            introduction: introduction,
            email: email,
            imageURL: image,
            provider: AuthProvider(rawValue: provider) ?? .unknown
        )
    }
}
