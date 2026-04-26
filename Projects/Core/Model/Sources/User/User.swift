import Foundation

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
