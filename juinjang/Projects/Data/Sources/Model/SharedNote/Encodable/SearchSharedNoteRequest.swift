import Foundation
import DomainModel

public struct SearchSharedNoteRequest: Encodable {
    let code: [String]?
    var sort: String
    var propertyType: String
    var priceType: String
    var keyword: String?
    let page: Int
    let size: Int
    
    init(_ model: SearchSharedNote) {
        code = model.code
        sort = model.sort
        propertyType = model.propertyType
        priceType = model.priceType
        keyword = model.keyword
        page = model.page
        size = model.size
    }
}
