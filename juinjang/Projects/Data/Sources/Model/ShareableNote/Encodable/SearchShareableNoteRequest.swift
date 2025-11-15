import Foundation
import DomainModel

public struct SearchShareableNoteRequest: Codable {
    let sort: String?
    let propertyType: String?
    let priceType: String?
    let keyword: String?
    let page: Int
    let size: Int
    
    init(_ model: SearchShareableNote) {
        sort = model.sort
        propertyType = model.propertyType
        priceType = model.priceType
        keyword = model.keyword
        page = model.page
        size = model.size
    }
}
