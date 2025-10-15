import Foundation
import CoreCommon
import DomainModel

public struct NoteImageInfoResponse: Codable, DomainMappable {
    let imageId: Int
    let imageUrl: String
    
    public func toDomain() -> NoteImageInfo {
        return NoteImageInfo.init(
            imageId: imageId,
            imageUrl: imageUrl
        )
    }
}
