//
//  ResultResponse.swift
//  Data
//
//  Created by 조유진 on 2/14/26.
//

struct ResultResponse<T: Decodable>: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String?
    let result: T?
}
