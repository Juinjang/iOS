import Foundation

public struct ExploreNoteRequest {
    let code: [String]?
    var sort: String
    var propertyType: String
    var priceType: String
    var keyword: String?
    let page: Int
    let size: Int
}

