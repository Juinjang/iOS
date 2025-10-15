import Foundation
import CoreCommon
import DomainModel

public struct LatestAppVersionResponse: Codable, DomainMappable {
    let version: String
    
    public func toDomain() -> LatestAppVersion {
        return LatestAppVersion.init(version: version)
    }
}
