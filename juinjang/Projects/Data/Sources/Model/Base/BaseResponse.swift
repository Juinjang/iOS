import Foundation
import Data

public struct BaseResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?
    
    public func unwrap() throws -> T {
        guard let result = result else {
            print("📌 NetworkError InvalidData")
            throw NetworkError.invalidData
        }
        return result
    }
}
