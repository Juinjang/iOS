import Foundation
import Core
import Domain

public struct NoteCompareListResponse: Codable, DomainMappable {
    var limjangList: [NoteCompareResponse]
    
    public func toDomain() -> NoteCompareList {
        return NoteCompareList.init(
            noteList: limjangList.map { $0.toDomain() }
        )
    }
}
