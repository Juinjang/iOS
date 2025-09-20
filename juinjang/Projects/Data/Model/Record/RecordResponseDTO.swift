import Foundation

public struct RecordResponseDTO: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: RecordDTO?
}
