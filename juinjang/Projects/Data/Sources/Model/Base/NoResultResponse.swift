import Foundation

public struct NoResultResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
}
