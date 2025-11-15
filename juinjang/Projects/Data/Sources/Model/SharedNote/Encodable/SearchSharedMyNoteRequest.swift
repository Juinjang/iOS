import Foundation
import DomainModel

public struct SearchSharedMyNoteRequest: Encodable {
    let noteType: String
    let propertyType: String?
    let priceType: String?
    let keyword: String?
    
    init(_ model: SearchSharedMyNote) {
        noteType = model.noteType
        propertyType = model.propertyType
        priceType = model.priceType
        keyword = model.keyword
    }
}
