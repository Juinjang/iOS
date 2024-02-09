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

struct NicknameDto: Decodable{
    let nickname: String
}
