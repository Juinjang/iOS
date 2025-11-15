import Foundation

public struct BaseResponseStringOptionalResult: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String?
}
