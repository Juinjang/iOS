//
//  BaseResponse.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation
import DataNetwork

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

public struct NoResultResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
}

public struct BaseResponseString: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

public struct BaseResponseStringOptionalResult: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String?
}
