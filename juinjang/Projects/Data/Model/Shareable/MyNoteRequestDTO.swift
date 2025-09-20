import Foundation

public struct MyNoteRequestDTO: Encodable {
    let noteType: String
    let propertyType: String?
    let priceType: String?
    let keyword: String?
}
