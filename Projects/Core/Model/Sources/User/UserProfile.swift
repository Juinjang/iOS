import Foundation

public struct UserProfile: Equatable, Sendable {
    public let nickname: String
    public let introduction: String?
    public let email: String
    public let imageURL: String?
    public let provider: AuthProvider

    public init(
        nickname: String,
        introduction: String?,
        email: String,
        imageURL: String?,
        provider: AuthProvider
    ) {
        self.nickname = nickname
        self.introduction = introduction
        self.email = email
        self.imageURL = imageURL
        self.provider = provider
    }
}
