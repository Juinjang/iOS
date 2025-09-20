import Foundation

public struct MemoDTO: Codable {
    let limjangId: Int
    let createdAt: String
    let updatedAt: String
    let memo: String?
}
