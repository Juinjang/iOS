import Foundation

public struct RecordMemoDTO: Codable {
    let limjangId: Int
    let memo: String?
    let createdAt: String
    let updatedAt: String
    let recordDto: [RecordResponse]
}
