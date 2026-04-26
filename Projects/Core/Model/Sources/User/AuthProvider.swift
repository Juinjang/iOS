import Foundation

public enum AuthProvider: String, Equatable, Codable, Sendable {
    case kakao = "KAKAO"
    case apple = "APPLE"
    case unknown

    public init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = AuthProvider(rawValue: raw) ?? .unknown
    }
}
