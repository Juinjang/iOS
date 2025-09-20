import Foundation

public struct LoginRequestBody: Decodable {
    let email: String
    let nickname: String?
}
