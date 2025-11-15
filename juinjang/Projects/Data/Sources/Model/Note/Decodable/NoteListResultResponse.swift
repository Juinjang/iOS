import Foundation

public struct NoteListResultResponse<T: Codable>: Codable {
    public let notes: [T]
}
