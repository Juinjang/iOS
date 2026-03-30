import Foundation

// MARK: - Domain Models

public struct Post: Equatable, Codable, Identifiable, Sendable {
    public let id: String
    public let title: String
    public let content: String
    public let authorId: String
    public let createdAt: Date

    public init(
        id: String,
        title: String,
        content: String,
        authorId: String,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.authorId = authorId
        self.createdAt = createdAt
    }
}

public struct User: Equatable, Codable, Identifiable, Sendable {
    public let id: String
    public let name: String
    public let profileImageURL: String?

    public init(
        id: String,
        name: String,
        profileImageURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.profileImageURL = profileImageURL
    }
}
