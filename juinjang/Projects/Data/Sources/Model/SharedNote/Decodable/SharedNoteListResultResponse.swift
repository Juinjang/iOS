import Foundation

public struct SharedNoteListResultResponse<T: Codable>: Codable {
    let notes: [T]
}
