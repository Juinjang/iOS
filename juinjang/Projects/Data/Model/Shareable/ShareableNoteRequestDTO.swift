import Foundation

public struct ShareableNoteRequestDTO: Codable {
    let sort: String?
    let propertyType: String?
    let priceType: String?
    let keyword: String?
    let page: Int
    let size: Int
}
