import Foundation

public struct NoteListResultResponse<T: Codable>: Codable {
    let notes: [T]
}
