//
//  LoginResponse.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

public struct LoginResponseDTO {
    let accessToken: String
    let refreshToken: String
}

public struct LoginResponse {
    let accessToken: String
    let refreshToken: String
    let email: String
    let agreeVersion: String
}
