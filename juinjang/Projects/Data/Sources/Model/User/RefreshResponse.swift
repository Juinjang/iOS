import Foundation
import CoreCommon
import DomainModel

public struct RefreshResponse: Codable, DomainMappable {
    let accessToken: String
    let refreshToken: String
    let email: String
    
    public func toDomain() -> Refresh {
        return Refresh.init(
            accessToken: accessToken,
            refreshToken: refreshToken,
            email: email
        )
    }
}
