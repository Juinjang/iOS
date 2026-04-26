import Foundation

// MARK: - iTunes Lookup API 응답 모델

public struct AppStoreLookupResponse: Decodable, Sendable {
    public struct Result: Decodable, Sendable {
        public let version: String?
    }
    public let results: [Result]
}
