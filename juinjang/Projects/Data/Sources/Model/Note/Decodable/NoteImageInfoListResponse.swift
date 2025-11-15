import Foundation
import CoreCommon
import DomainModel

public struct NoteImageInfoListDTO: Codable, DomainMappable {
    let images: [NoteImageInfoResponse]
    
    public func toDomain() -> NoteImageInfoList {
        return NoteImageInfoList.init(
            images: images
        )
    }
}
