import Foundation
import Core
import Domain

public struct ProfileResponse: Codable, DomainMappable {
    let nickname: String
    let email: String
    let provider: String
    let image: String?
    let introduction: String?
    
    public func toDomain() -> Profile {
        return Profile.init(
            nickname: nickname,
            introduction: introduction,
            email: email,
            image: image,
            provider: provider
        )
    }
}

