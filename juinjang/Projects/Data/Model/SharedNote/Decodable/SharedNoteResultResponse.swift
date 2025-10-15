import Foundation

public struct SharedNoteResultResponse: Codable {
    let totalResults: Int
    let notes: [SharedNoteResponse]
}
