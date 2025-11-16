import Foundation
import Core
import Domain

public struct LoginResponse: Codable, DomainMappable {
    let accessToken: String
    let refreshToken: String
    let email: String
    let agreeVersion: String
    
    public func toDomain() -> Login {
        return Login.init(
            accessToken: accessToken,
            refreshToken: refreshToken,
            email: email,
            agreeVersion: agreeVersion
        )
    }
}
