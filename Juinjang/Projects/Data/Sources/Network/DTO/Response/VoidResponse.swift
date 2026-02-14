//
//  VoidResponse.swift
//  Data
//
//  Created by 조유진 on 2/14/26.
//

struct VoidResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String?
}
