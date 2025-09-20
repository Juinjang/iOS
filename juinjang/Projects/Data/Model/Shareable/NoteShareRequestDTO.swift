import Foundation

public struct NoteShareRequestDTO: Encodable {
    let buildingName: String
    let isImageShared: Bool
    let year: Int
    let month: Int
    let period: String
    let review: String
}
