import Foundation

public struct BaseResponseString: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}
