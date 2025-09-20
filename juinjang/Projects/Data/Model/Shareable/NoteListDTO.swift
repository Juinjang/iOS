import Foundation

public struct NoteListDTO<T: Codable>: Codable {
    let notes: [T]
}
