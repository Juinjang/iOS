import Foundation

public struct ExploreNoteResponseDTO: Codable {
    let totalResults: Int
    let notes: [ExploreNoteModel]
}
