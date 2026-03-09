import Foundation

// MARK: - 공통 API 응답 (데이터 없음)

public struct VoidResponse: Decodable {
    public let isSuccess: Bool
    public let code: String
    public let message: String?
}
