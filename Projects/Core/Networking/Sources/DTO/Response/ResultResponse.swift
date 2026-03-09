import Foundation

// MARK: - 공통 API 응답 (데이터 포함)

public struct ResultResponse<T: Decodable>: Decodable {
    public let isSuccess: Bool
    public let code: String
    public let message: String?
    public let result: T?
}
