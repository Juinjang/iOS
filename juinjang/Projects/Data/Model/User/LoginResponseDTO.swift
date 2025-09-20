import Foundation

public struct LoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
