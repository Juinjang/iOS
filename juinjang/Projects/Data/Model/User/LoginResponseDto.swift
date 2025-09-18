//
//  LoginResponseDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct LoginResponseDto: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct NicknameDto: Codable{
    let nickname: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let email: String
    let agreeVersion: String
}

struct LoginRequestBody: Decodable {
    let email: String
    let nickname: String?
}
