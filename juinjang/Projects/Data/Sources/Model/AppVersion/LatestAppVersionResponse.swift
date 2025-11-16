import Foundation
import Core
import Domain

public struct LatestAppVersionResponse: Codable, DomainMappable {
    let version: String
    
    public func toDomain() -> LatestAppVersion {
        return LatestAppVersion.init(version: version)
    }
}
