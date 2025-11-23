//
//  BaseResponse.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?
    
    func unwrap() throws -> T {
        guard let result = result else {
            print("📌 NetworkError InvalidData")
            throw NetworkError.invalidData
        }
        return result
    }
}

struct NoResultResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
}

struct BaseResponseString: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}

struct BaseResponseStringOptionalResult: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String?
}
